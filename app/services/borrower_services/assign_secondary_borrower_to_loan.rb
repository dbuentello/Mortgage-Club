module BorrowerServices
  class AssignSecondaryBorrowerToLoan
    attr_accessor :loan, :owner, :secondary_borrower, :params

    def initialize(loan, params, secondary_borrower)
      @loan = loan
      @params = params
      @owner = existing_user ? existing_user : create_owner
      @secondary_borrower = secondary_borrower
      @new_secondary_borrower = loan_has_new_secondary_borrower?(secondary_borrower)
    end

    def call
      return unless owner

      owner.borrower = secondary_borrower
      loan.secondary_borrower = secondary_borrower
      owner.save
      loan.save

      send_email_to_secondary_borrower if @new_secondary_borrower
    end

    private

    def existing_user
      @existing_user ||= User.where(email: params[:secondary_borrower][:email]).last
    end

    def create_owner
      user_form = UserForm.new(params: user_params, skip_confirmation: true)
      return user_form.user if user_form.save
    end

    def default_password
      @default_password ||= Digest::MD5.hexdigest(params[:secondary_borrower][:email]).first(10)
    end

    def send_email_to_secondary_borrower
      if existing_user.present?
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
      user_params[:user] = params[:secondary_borrower]
      user_params[:user][:password] = user_params[:user][:password_confirmation] = default_password
      user_params
    end
  end
end