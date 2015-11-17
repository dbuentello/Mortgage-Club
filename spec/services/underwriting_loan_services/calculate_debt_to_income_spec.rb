require "rails_helper"

describe UnderwritingLoanServices::CalculateDebtToIncome do
  let(:loan) { FactoryGirl.create(:loan) }
  let!(:primary_property) { FactoryGirl.create(:rental_property, is_primary: true, loan: loan) }
  let!(:first_property) { FactoryGirl.create(:rental_property, is_primary: false, loan: loan) }
  let!(:second_property) { FactoryGirl.create(:rental_property, is_primary: false, loan: loan) }
  let!(:mortgage_liability) { FactoryGirl.create(:liability, account_type: "Mortgage", property: first_property) }
  let!(:other_liability) { FactoryGirl.create(:liability, account_type: "OtherFinancing", property: second_property) }

  describe ".sum_investment" do
    it "returns sum of property's investment" do
      sum = first_property.mortgage_payment + first_property.other_financing +
            second_property.mortgage_payment + second_property.other_financing
      expect(
        UnderwritingLoanServices::CalculateDebtToIncome.sum_investment(
          loan.rental_properties
        )
      ).to eq(sum)
    end
  end
end
