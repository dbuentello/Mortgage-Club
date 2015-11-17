require "rails_helper"

describe UnderwritingLoanServices::CalculateTotalIncome do
  let!(:loan) { FactoryGirl.create(:loan) }
  before(:each) { allow(UnderwritingLoanServices::CalculateRentalIncome).to receive(:call).and_return(0) }

  it "calls CalculateRentalIncome service" do
    expect(UnderwritingLoanServices::CalculateRentalIncome).to receive(:call)
    UnderwritingLoanServices::CalculateTotalIncome.call(loan)
  end

  it "returns a right total income" do
    total_income = loan.borrower.current_salary + loan.borrower.gross_overtime.to_f + loan.borrower.gross_commission.to_f + 0
    expect(UnderwritingLoanServices::CalculateTotalIncome.call(loan)).to eq(total_income)
  end
end
