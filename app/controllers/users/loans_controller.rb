class Users::LoansController < Users::BaseController
  before_action :set_loan, only: [:edit, :update, :destroy]
  before_action :load_liabilities, only: [:edit]

  def index
    if current_user.loans.size < 1
      loan = Loan.initiate(current_user)
      return redirect_to edit_loan_path(loan)
    end

    ref_url = "#{url_for(:only_path => false)}?refcode=#{current_user.id}"
    invites = Invite.where(sender_id: current_user.id)
    @ref_code = params[:refcode]

    bootstrap(
      loans: LoanListPage::LoansPresenter.new(current_user.loans).show,
      invites: LoanListPage::InvitesPresenter.new(invites).show,
      refCode: @ref_code,
      refLink: ref_url,
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def create
    @loan = Loan.initiate(current_user)

    if @loan.save
      flash[:success] = "Sucessfully create a new loan"
      render json: {loan_id: @loan.id}, status: 200
    else
      render json: {message: "Cannot create new loan"}, status: 500
    end
  end

  def edit
    bootstrap({
      currentLoan: LoanEditPage::LoanPresenter.new(@loan).show,
      liabilities: @liabilities,
      borrower_type: (@borrower_type == :borrower) ? "borrower" : "co_borrower"
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def update
    if @loan.update(loan_params)
      loan = @loan.reload
      step = params[:current_step].to_s if params[:current_step].present?
      case step
      when '0'
        loan.update(amount: loan.subject_property.purchase_price.to_f * 0.8)
        ZillowService::UpdatePropertyTax.delay.call(loan.subject_property.id)
        if loan.subject_property.address && loan.subject_property.address.zip
          ZillowService::GetMortgageRates.new(loan.id, loan.subject_property.address.zip).delay.call
        end
      when '3'
        # CreditReportService.delay.get_liabilities(current_user.borrower)
      end

      render json: {loan: LoanEditPage::LoanPresenter.new(loan).show}
    else
      render json: {error: @loan.errors.full_messages}, status: 500
    end
  end

  def destroy
    if @loan.destroy
      flash[:success] = "Sucessfully destroy loan"

      render json: {redirect_path: my_loans_path}, status: 200
    else
      render json: {message: "Cannot destroy loan"}, status: 500
    end
  end

  # GET get_co_borrower_info
  # def get_secondary_borrower_info
  #   is_existing = Form::CoBorrower.check_existing_borrower(current_user, params[:email])

  #   if is_existing
  #     is_valid = Form::CoBorrower.check_valid_borrower(borrower_info_params)

  #     if is_valid
  #       user = User.where(email: params[:email]).first
  #       borrower = user.borrower

  #       render json: {secondary_borrower: BorrowerPresenter.new(borrower).show}, status: :ok
  #     else
  #       render json: {message: 'Invalid email or date of birth or social security number'}, status: :ok
  #     end
  #   else
  #     render json: {message: 'Not found'}, status: :ok
  #   end
  # end

  private

  def load_liabilities
    credit_report = @loan.borrower.credit_report
    if credit_report.present? && !credit_report.liabilities.blank?
      @liabilities = credit_report.liabilities
    else
      @liabilities = CreditReportServices::ParseSampleXml.call(@loan.borrower)
    end
  end

  def loan_params
    params.require(:loan).permit(Loan::PERMITTED_ATTRS)
  end

  def co_borrower_params
    if params[:loan][:secondary_borrower_attributes].present?
      permit_attrs = Borrower::PERMITTED_ATTRS + [:email, :_remove]
      params.require(:loan).require(:secondary_borrower_attributes).permit(permit_attrs)
    else
      nil
    end
  end

  def borrower_info_params
    params.permit([:email, :dob, :ssn])
  end
end