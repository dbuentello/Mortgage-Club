class Admins::LoanUrlTokensController < Admins::BaseController
  before_action :set_loan, except: [:index]

  def index
    loans = Loan.all.includes(:user)
    borrowers = Borrower.all
    host_name = ENV.fetch("HOST_NAME", "localhost:4000")
    url = edit_user_password_url(host: host_name)

    bootstrap(
      loans: Admins::LoansPresenter.new(loans).show,
      borrowers: Admins::BorrowersPresenter.new(borrowers).show,
      url: url
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def create
    GeneratePreparedLoanUrlTokenService.call(@loan)
    loans = Loan.all.includes(:user)

    render json: {
      loans: Admins::LoansPresenter.new(loans).show
    }, status: 200
  end
end
