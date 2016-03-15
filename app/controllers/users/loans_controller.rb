class Users::LoansController < Users::BaseController
  before_action :set_loan, only: [:edit, :update, :destroy, :show]
  before_action :load_liabilities, only: [:edit, :show]

  def index
    if current_user.loans.size < 1
      loan = InitializeFirstLoanService.new(current_user, cookies[:initial_quotes]).call
      delete_quote_cookies
      return redirect_to edit_loan_path(loan)
    end

    ref_url = "#{url_for(only_path: false)}?refcode=#{current_user.id}"
    invites = Invite.where(sender_id: current_user.id).order(created_at: :desc)

    bootstrap(
      loans: LoanListPage::LoansPresenter.new(current_user.loans).show,
      invites: LoanListPage::InvitesPresenter.new(invites).show,
      user: LoanListPage::UserPresenter.new(current_user).show,
      refCode: params[:refcode],
      refLink: ref_url,
      user_email: current_user.email,
      commonInfo: get_common_info
    )

    respond_to do |format|
      format.html { render template: "borrower_app".freeze }
    end
  end

  def get_common_info
    list = {}
    info = current_user.loans.joins(properties: :address).where("properties.is_subject = true".freeze).pluck("loans.id".freeze, "addresses.street_address".freeze, "addresses.city".freeze, "addresses.state".freeze, "addresses.zip".freeze, "properties.zillow_image_url".freeze)

    info.each do |i|
      loan_id = i[0]
      street_address = i[1]
      city = i[2]
      state = i[3]
      zip = i[4]
      zillow_image_url = i[5]

      list[loan_id] = {
        zillow_image_url: zillow_image_url,
        address: street_address.nil? ? "Unknown Address".freeze : "#{street_address}, #{city}, #{state} #{zip}"
      }
    end
    list
  end

  def create
    @loan = InitializeFirstLoanService.new(current_user, cookies[:initial_quotes]).call
    delete_quote_cookies

    if @loan.save
      render json: {loan_id: @loan.id}, status: 200
    else
      render json: {message: "Cannot create new loan"}, status: 500
    end
  end

  def edit
    return redirect_to action: :show unless @loan.new_loan?

    bootstrap(
      currentLoan: LoanEditPage::LoanPresenter.new(@loan).show,
      liabilities: @liabilities,
      borrower_type: (@borrower_type == :borrower) ? "borrower" : "co_borrower",
      is_edit_mode: true
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def show
    return redirect_to action: :edit if @loan.new_loan?

    bootstrap(
      currentLoan: LoanEditPage::LoanPresenter.new(@loan).show,
      liabilities: @liabilities,
      borrower_type: (@borrower_type == :borrower) ? "borrower" : "co_borrower",
      is_edit_mode: false
    )

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
        ZillowService::UpdatePropertyTax.delay.call(loan.subject_property.id)
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
      # flash[:success] = "Sucessfully destroy loan"

      render json: {redirect_path: my_loans_path}, status: 200
    else
      render json: {message: "Cannot destroy loan"}, status: 500
    end
  end

  private

  def delete_quote_cookies
    cookies.delete(:initial_quotes) if cookies[:initial_quotes]
  end

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
    return unless params[:loan][:secondary_borrower_attributes].present?

    permit_attrs = Borrower::PERMITTED_ATTRS + [:email, :_remove]
    params.require(:loan).require(:secondary_borrower_attributes).permit(permit_attrs)
  end

  def borrower_info_params
    params.permit([:email, :dob, :ssn])
  end
end