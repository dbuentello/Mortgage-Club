require "rails_helper"

describe UnderwritingLoanServices::CalculateRentalIncome do
  let(:loan) { FactoryGirl.create(:loan) }
  let!(:first_property) { FactoryGirl.create(:rental_property, is_primary: false, loan: loan) }
  let!(:second_property) { FactoryGirl.create(:rental_property, is_primary: false, loan: loan) }

  it "returns a right rental income" do
    right_rental_income = (first_property.actual_rental_income - first_property.liability_payments -
                            first_property.estimated_property_tax - first_property.estimated_hazard_insurance -
                            first_property.estimated_mortgage_insurance - first_property.hoa_due
                          ) +
                          (second_property.actual_rental_income - second_property.liability_payments -
                            second_property.estimated_property_tax - second_property.estimated_hazard_insurance -
                            second_property.estimated_mortgage_insurance - second_property.hoa_due
                          )
    expect(UnderwritingLoanServices::CalculateRentalIncome.call(loan)).to eq(right_rental_income)
  end
end
