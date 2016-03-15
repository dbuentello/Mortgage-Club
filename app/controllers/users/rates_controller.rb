class Users::RatesController < Users::BaseController
  def index
    @loan = Loan.find(params[:loan_id])

    return redirect_to edit_loan_url(@loan) unless @loan.completed?

    rate_programs = []
    if @loan.subject_property.address && zipcode = @loan.subject_property.address.zip
      rate_programs = LoanTekServices::GetQuotes.new(@loan).call
    end

    bootstrap({
      currentLoan: LoanProgram::LoanProgramPresenter.new(@loan).show,
      programs: rate_programs
    })

    render template: 'borrower_app'
  end
end
