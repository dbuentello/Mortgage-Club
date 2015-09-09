class Admins::LoanMemberManagementsController < Admins::BaseController
  before_action :set_loan_member, except: [:index, :create]

  def index
    loans = Loan.all
    loan_members = LoanMember.all

    bootstrap(
      loans: LoansPresenter.new(loans).show,
      loan_members: LoanMembersPresenter.index(loan_members),
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(
      loan_member: LoanMembersPresenter.show(@loan_member)
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @loan_member.update(loan_member_params) && @loan_member.user.update(user_params)
      render json: {loan_member: LoanMembersPresenter.show(@loan_member), message: 'Updated sucessfully'}, status: 200
    else
      render json: {message: "Updated failed"}, status: 500
    end
  end

  def create
    default_password = 'loan_member_password'
    @user = User.new(user_params.merge(password: default_password, password_confirmation: default_password))
    @user.skip_confirmation! unless params[:send_confirmation_email]
    @loan_member = @user.build_loan_member(loan_member_params)

    if @user.save
      @user.add_role :loan_member

      render json: {
        loan_member: LoanMembersPresenter.show(@loan_member),
        loan_members: LoanMembersPresenter.index(LoanMember.all),
        message: 'Created sucessfully'
      }, status: 200
    else
      render json: {message: @user.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @loan_member.user.destroy
      render json: {
        message: "Removed the #{@loan_member.user.to_s} successfully",
        loan_members: LoanMembersPresenter.index(LoanMember.all)
      }, status: 200
    else
      render json: {message: "Cannot remove the checklist"}, status: 500
    end
  end

  private

  def loan_member_params
    params.require(:loan_member).permit(:phone_number, :skype_handle)
  end

  def user_params
    params.require(:loan_member).permit(:email, :first_name, :last_name, :avatar)
  end

  def set_loan_member
    @loan_member = LoanMember.find(params[:id])
  end
end