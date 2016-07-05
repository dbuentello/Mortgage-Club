require "rails_helper"

describe UnderwritingLoanServices::CalculateHousingExpenseRatio do
  let(:loan) { FactoryGirl.create(:loan) }
  let!(:subject_property) { FactoryGirl.create(:rental_property, is_subject: true, loan: loan) }

  it "returns housing expense ratio" do
    total_income = UnderwritingLoanServices::CalculateTotalIncome.call(loan)
    ratio = (subject_property.liability_payments + subject_property.estimated_mortgage_insurance +
            subject_property.estimated_hazard_insurance + subject_property.estimated_property_tax +
            subject_property.hoa_due) / total_income

    expect(UnderwritingLoanServices::CalculateHousingExpenseRatio.call(loan)).to eq(ratio)
  end
end
