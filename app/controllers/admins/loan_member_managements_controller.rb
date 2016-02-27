class Admins::LoanMemberManagementsController < Admins::BaseController
  before_action :set_loan_member, except: [:index, :create]

  def index
    loans = Loan.all
    loan_members = LoanMember.all

    bootstrap(
      loans: Admins::LoansPresenter.new(loans).show,
      loan_members: Admins::LoanMembersPresenter.new(loan_members).show,
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(
      loan_member: Admins::LoanMemberPresenter.new(@loan_member).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @loan_member.update(loan_member_params) && @loan_member.user.update(user_params)
      render json: {loan_member: Admins::LoanMemberPresenter.new(@loan_member).show, message: 'Updated sucessfully'}, status: 200
    else
      render json: {message: "Updated failed"}, status: 500
    end
  end

  def create
    @user = User.new(user_params.merge(password_confirmation: user_params[:password]))
    @user.skip_confirmation!
    @loan_member = @user.build_loan_member(loan_member_params)

    if @user.save
      @user.add_role :loan_member

      render json: {
        loan_member: Admins::LoanMemberPresenter.new(@loan_member).show,
        loan_members: Admins::LoanMembersPresenter.new(LoanMember.all).show,
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
        loan_members: Admins::LoanMembersPresenter.new(LoanMember.all).show
      }, status: 200
    else
      render json: {message: "Cannot remove the checklist"}, status: 500
    end
  end

  private

  def loan_member_params
    params.require(:loan_member).permit(:phone_number)
  end

  def user_params
    params.require(:loan_member).permit(:email, :first_name, :last_name, :avatar, :password)
  end

  def set_loan_member
    @loan_member = LoanMember.find(params[:id])
  end
end