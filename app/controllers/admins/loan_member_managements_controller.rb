class Admins::LoanMemberManagementsController < Admins::BaseController
  before_action :set_loan_member, except: [:index, :create]

  def index
    loans = Loan.all.includes(:user, properties: :address)
    loan_members = LoanMember.all

    bootstrap(
      loans: Admins::LoansPresenter.new(loans).show,
      loan_members: Admins::LoanMembersPresenter.new(loan_members).show
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
      render json: {loan_member: Admins::LoanMemberPresenter.new(@loan_member).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @user = User.new(user_params.merge(password_confirmation: user_params[:password]))
    @user.skip_confirmation!

    if @user.save
      @loan_member = @user.build_loan_member(loan_member_params)
      if @loan_member.save
        @user.add_role :loan_member
        render json: {
          loan_member: Admins::LoanMemberPresenter.new(@loan_member).show,
          loan_members: Admins::LoanMembersPresenter.new(LoanMember.all).show,
          message: t("info.success", status: t("common.status.created"))
        }, status: 200
      else
        @user.destroy
        render json: {message: @loan_member.errors.full_messages.first}, status: 500
      end
    else
      render json: {message: @user.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @loan_member.user.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        loan_members: Admins::LoanMembersPresenter.new(LoanMember.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove"))}, status: 500
    end
  end

  private

  def loan_member_params
    params.require(:loan_member).permit(:phone_number, :nmls_id, :company_name, :company_address, :company_phone_number, :company_nmls)
  end

  def user_params
    params.require(:loan_member).permit(:email, :first_name, :last_name, :avatar, :password)
  end

  def set_loan_member
    @loan_member = LoanMember.find(params[:id])
  end
end
