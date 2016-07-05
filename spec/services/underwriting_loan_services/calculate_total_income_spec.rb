require "rails_helper"

describe UnderwritingLoanServices::CalculateTotalIncome do
  let!(:loan) { FactoryGirl.create(:loan) }
  before(:each) { allow(UnderwritingLoanServices::CalculateRentalIncome).to receive(:call).and_return(0) }

  it "calls CalculateRentalIncome service" do
    expect(UnderwritingLoanServices::CalculateRentalIncome).to receive(:call)
    UnderwritingLoanServices::CalculateTotalIncome.call(loan)
  end

  it "returns a right total income" do
    total_income = loan.borrower.current_salary.to_f + loan.borrower.gross_overtime.to_f + loan.borrower.gross_commission.to_f + 0
    expect(UnderwritingLoanServices::CalculateTotalIncome.call(loan)).to eq(total_income)
  end

  it "returns a right total income with co-borrower" do
    loan_co_borrower = FactoryGirl.create(:loan_with_secondary_borrower)
    total_income = loan_co_borrower.borrower.current_salary.to_f + loan_co_borrower.borrower.gross_overtime.to_f + loan_co_borrower.borrower.gross_commission.to_f + 0 + loan_co_borrower.secondary_borrower.current_salary.to_f + loan_co_borrower.secondary_borrower.gross_overtime.to_f + loan_co_borrower.secondary_borrower.gross_commission.to_f

    expect(UnderwritingLoanServices::CalculateTotalIncome.call(loan_co_borrower)).to eq(total_income)
  end
end
