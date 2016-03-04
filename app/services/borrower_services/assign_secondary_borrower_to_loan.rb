module BorrowerServices
  class AssignSecondaryBorrowerToLoan
    attr_accessor :loan, :owner, :secondary_borrower, :secondary_params, :is_new_user

    def initialize(loan, secondary_params, secondary_borrower)
      @is_new_user = false
      @loan = loan
      @secondary_params = secondary_params
      @owner = existing_user ? existing_user : create_owner
      @secondary_borrower = secondary_borrower
      @new_secondary_borrower = loan_has_new_secondary_borrower?(secondary_borrower)
    end

    def call
      unless owner && secondary_params[:borrower][:email].present?
        destroy_secondary_borrower
        return
      end

      ActiveRecord::Base.transaction do
        owner.borrower = secondary_borrower
        loan.secondary_borrower = secondary_borrower
        loan.save
        send_email_to_secondary_borrower if @new_secondary_borrower
      end
    end

    private

    def existing_user
      @existing_user ||= User.where(email: secondary_params[:borrower][:email]).last
    end

    def create_owner
      user_form = UserForm.new(params: user_params, skip_confirmation: true)
      return unless user_form.save
      user_form.save
      @is_user = true
      user_form.user
    end

    def default_password
      @default_password ||= Digest::MD5.hexdigest(secondary_params[:borrower][:email]).first(10)
    end

    def send_email_to_secondary_borrower
      if @is_new_user
        email_options = {is_new_user: false, default_password: nil}
      else
        email_options = {is_new_user: true, default_password: default_password}
      end

      CoBorrowerMailer.notify_being_added(loan.id, email_options).deliver_later
    end

    def loan_has_new_secondary_borrower?(secondary_borrower)
      loan.secondary_borrower.nil? || (loan.secondary_borrower != secondary_borrower)
    end

    def user_params
      user_params = {}
      user_params[:user] = secondary_params[:borrower]
      user_params[:user][:password] = user_params[:user][:password_confirmation] = default_password
      user_params
    end

    def destroy_secondary_borrower
      secondary_borrower.destroy
    end
  end
end