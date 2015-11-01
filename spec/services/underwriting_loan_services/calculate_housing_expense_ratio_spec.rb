require "rails_helper"

describe UnderwritingLoanServices::CalculateHousingExpenseRatio do
  let(:loan) { FactoryGirl.create(:loan) }
  let!(:primary_property) { FactoryGirl.create(:rental_property, is_primary: true, loan: loan) }

  it "returns housing expense ratio" do
    ratio = (primary_property.liability_payments + primary_property.estimated_mortgage_insurance +
            primary_property.estimated_hazard_insurance + primary_property.estimated_property_tax +
            primary_property.hoa_due) / loan.borrower.total_income

    expect(UnderwritingLoanServices::CalculateHousingExpenseRatio.call(loan)).to eq(ratio)
  end
end
