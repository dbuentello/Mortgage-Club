#
# Class Users::RatesController provides index method to show list rates for borrower after filling full information
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
class Users::RatesController < Users::BaseController
  #
  # Get list rates
  #
  # @return [HTML] borrower app with boostrap data includes currentLoan, programs
  #
  def index
    @loan = Loan.find(params[:loan_id])
    return redirect_to edit_loan_url(@loan) unless @loan.completed?

    rate_programs = []
    if @loan.subject_property.address && @loan.subject_property.address.zip
      rate_programs = LoanTekServices::GetQuotes.new(@loan).call
    end
    @selected_program = 0
    @selected_program = 1 if @loan.lender_name.present?
    bootstrap(
      currentLoan: LoanProgram::LoanProgramPresenter.new(@loan).show,
      programs: filter_program(rate_programs),
      selected_program: @selected_program
    )
    render template: 'borrower_app'
  end

  private
  def filter_program(rate_programs)
    rate_programs.each do |r|
      if(r[:lender_name] == @loan.lender_name && r[:product] == @loan.amortization_type && r[:interest_rate] == @loan.interest_rate)
        @selected_program = 2
        r[:selected_program] = true
      else
        r[:selected_program] = false
      end
    end
    rate_programs
  end
end
