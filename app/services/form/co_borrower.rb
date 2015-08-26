module Form
  class CoBorrower
    def self.check_existing_borrower(current_user, borrower_email)
      user = User.where(email: borrower_email).first

      if user.present? && user != current_user
        return true
      else
        return false
      end
    end

    def self.save(current_user, borrower_type, params = {}, loan)
      borrower_params = params.except(:email)
      case borrower_type
      when :borrower
        is_existing = check_existing_borrower(current_user, params[:email])

        if is_existing
          user = User.where(email: params[:email]).first
          borrower = user.borrower
          # don't allow edit borrower info when he/she already exists
          # borrower.update(borrower_params)
        else
          # create user corresponding with the co-borrower info
          default_password = Digest::MD5.hexdigest(params[:email]).first(10)

          user = User.new(
            email: params[:email],
            first_name: params[:first_name], last_name: params[:last_name], middle_name: params[:middle_name],
            password: default_password, password_confirmation: default_password,
            #borrower_attributes: borrower_params
          )
          byebug
          user.skip_confirmation!
          user.save
          user.reload
        end

        # link that new borrower as co-borrower of current loan
        loan.secondary_borrower = user.borrower
        loan.save

        # send email to co-borrower to let him know
        email_options = {
          is_new_user: !is_existing,
          default_password: default_password || nil
        }
        CoBorrowerMailer.notify_being_added(loan.id, email_options).deliver_later
      when :secondary_borrower
        # just update its info
        borrower = current_user.borrower
        borrower.update(borrower_params)
      end
    end

    def self.remove(current_user, borrower_type, params = {}, loan)
      case borrower_type
      when :borrower
        # unlink that borrower as co-borrower of current loan
        secondary_borrower = loan.secondary_borrower

        if secondary_borrower
          # remove secondary borrower from the loan
          secondary_borrower.loan = nil
          secondary_borrower.save

          # send email to co-borrower to let him know
          CoBorrowerMailer.notify_being_removed(loan.id, secondary_borrower.id).deliver_later
        end

      when :secondary_borrower
        secondary_borrower = current_user.borrower
        loan = secondary_borrower.loan

        if loan
          # remove secondary borrower from the loan
          secondary_borrower.loan = nil
          secondary_borrower.save

          # send email to borrower to let him know
          CoBorrowerMailer.notify_being_leaving(loan.id, secondary_borrower.id).deliver_later
        end
      end

    end

    def self.check_valid_borrower(params = {})
      return false unless params[:email] && params[:ssn] && params[:dob]

      borrower = Borrower.where(ssn: params[:ssn]).first

      if borrower.present? && (borrower.user.email == params[:email]) && (DateTime.parse(params[:dob]).utc.to_date == borrower.dob.to_date)
        return true
      else
        return false
      end
    end

  end
end
