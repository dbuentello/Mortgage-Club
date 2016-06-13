class Users::LoansController < Users::BaseController
  before_action :set_loan, only: [:edit, :update, :destroy, :show, :update_income]
  before_action :load_liabilities, only: [:edit, :show]

  # Show list of user loans
  # the page is redirected after user login to system.
  # If user has no loan, Sys will create a First loan for user.
  # The first loan could be created by the data from initial quotes ( /quotes )
  #
  # @return [Object] bootstrap data and borrower_app template
  def index
    if current_user.loans.size < 1
      loan = InitializeFirstLoanService.new(current_user, cookies[:initial_quotes]).call
      delete_quote_cookies
      return redirect_to edit_loan_path(loan)
    end
    ref_url = "#{url_for(only_path: false)}?refcode=#{current_user.id}"
    invites = Invite.where(sender_id: current_user.id).order(created_at: :desc)
    byebug
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

  # Get info of address and zillow image url for user loans.
  #
  # @return [array] list address info and zillow image url
  def get_common_info
    list = {}
    byebug
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

  # Create a new loan for current user.
  # new loan can use initial_quotes cookies info if it exist.
  #
  # @return [JSON] loan_id (200) or error message (500)
  # if system cant create loan.
  def create
    @loan = InitializeFirstLoanService.new(current_user, cookies[:initial_quotes]).call
    delete_quote_cookies

    if @loan.save
      render json: {loan_id: @loan.id}, status: 200
    else
      render json: {message: t("users.loans.create.add_failed")}, status: 500
    end
  end

  # get info to edit loan.
  # if the loan's status is not 'new', will redirect_to show.
  #
  # @return [HTML] Borrower_app template (react) with bootstrap data (currentLoan, liabilities, borrower_type, is_edit_mode)
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

  # get the latest loan data.
  #
  # @return [JSON] latest loan data
  def update_income
    render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show}
  end

  # Show loan in show mode. User cant edit anything.
  # if loan's status is 'new', will redirect_to edit action
  #
  # @return [HTML] borrower_app (react) with bootstrap data (currentLoan, liabilities, borrower_type, is_edit_mode)
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


  # get borrower other document to reload the document page after user uploads a new other document.
  # TODO: check if not found
  # @return [JSON] Other documents of borrower
  def borrower_other_documents
    render json: {
      borrower_documents: LoanEditPage::BorrowerDocumentsPresenter.new(Borrower.find(params[:borrower_id]).other_documents).show
    }, status: 200
  end

  def update
    if @loan.update(loan_params)
      loan = @loan.reload
      render json: {loan: LoanEditPage::LoanPresenter.new(loan).show}
    else
      render json: {error: @loan.errors.full_messages}, status: 500
    end
  end

  def destroy
    if @loan.destroy
      render json: {redirect_path: my_loans_path}, status: 200
    else
      render json: {message: t("users.loans.destroy.destroy_failed")}, status: 500
    end
  end

  private

  def delete_quote_cookies
    cookies.delete(:initial_quotes) if cookies[:initial_quotes]
  end

  def load_liabilities
    if @loan.borrower.current_address && @loan.borrower.current_address.address && @loan.borrower.credit_report
      @liabilities = @loan.borrower.credit_report.liabilities
    else
      @liabilities = []
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

end
