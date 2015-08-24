class Users::LoansController < Users::BaseController
  before_action :set_loan, only: [:dashboard, :edit, :update, :destroy]

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
      currentLoan: LoanPresenter.new(@loan).edit_loan,
      borrower_type: (@borrower_type == :borrower) ? "borrower" : "co_borrower"
    })

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def update
    @borrower_params = co_borrower_params
    if @borrower_params.present?
      if @borrower_params[:_remove]
        Form::CoBorrower.remove(current_user, @borrower_type, @borrower_params)
      else
        Form::CoBorrower.save(current_user, @borrower_type, @borrower_params)
      end
    end

    if @loan.update(loan_params)
      loan = @loan.reload
      ZillowService::UpdatePropertyTax.delay.call(loan.property.id)

      render json: {loan: LoanPresenter.new(loan).edit_loan}
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
  def get_co_borrower_info
    is_existing = Form::CoBorrower.check_existing_borrower(current_user, params[:email])

    if is_existing
      is_valid = Form::CoBorrower.check_valid_borrower(borrower_info_params)

      if is_valid
        user = User.where(email: params[:email]).first
        borrower = user.borrower

        render json: {secondary_borrower: BorrowerPresenter.new(borrower).show_borrower}, status: :ok
      else
        render json: {message: 'Invalid email or date of birth or social security number'}, status: :ok
      end
    else
      render json: {message: 'Not found'}, status: :ok
    end
  end

  def index
    loans = current_user.loans.includes(property: :address)

    bootstrap(
      loans: LoanPresenter.new(loans).show_loan
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def dashboard
    borrower = current_user.borrower

    loan = @loan
    property = loan.property
    closing = loan.closing || Closing.create(name: 'Closing', loan_id: loan.id)
    loan_activities = loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10)

    loan_presenter = LoanPresenter.new(loan)
    bootstrap(
      address: property.address.try(:address),
      loan: loan_presenter.show_loan,
      borrower_list: BorrowerPresenter.new(borrower).show_documents,
      contact_list: contact_list_json_options,
      property_list: PropertyPresenter.new(property).show_documents,
      loan_list: loan_presenter.show_documents,
      loan_activities: loan_activities,
      closing_list: ClosingPresenter.new(closing).show_documents
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  private

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

  def contact_list_json_options
    [
      {
        id: 1,
        name: 'Michael Gifford',
        title: 'Relationship Manager',
        email: 'michael@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      },
      {
        id: 2,
        name: 'Jerry Williams',
        title: 'Loan Analyst',
        email: 'jerry@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      },
      {
        id: 3,
        name: 'Kristina Rendon',
        title: 'Insurance',
        email: 'kristina@gmail.com',
        avatar_url: 'https://goo.gl/IpbO1e'
      }
    ]
  end

end