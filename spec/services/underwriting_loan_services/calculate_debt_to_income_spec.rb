require "rails_helper"

describe UnderwritingLoanServices::CalculateDebtToIncome do
  let(:loan) { FactoryGirl.create(:loan) }
  let!(:primary_property) { FactoryGirl.create(:rental_property, is_primary: true, loan: loan) }
  let!(:first_property) { FactoryGirl.create(:rental_property, is_primary: false, loan: loan) }
  let!(:second_property) { FactoryGirl.create(:rental_property, is_primary: false, loan: loan) }
  let!(:mortgage_liability) { FactoryGirl.create(:liability, liability_type: "Mortgage", property: first_property) }
  let!(:other_liability) { FactoryGirl.create(:liability, liability_type: "OtherFinancing", property: second_property) }

  describe ".sum_liability_payment" do
    it "returns sum of liability's payment" do
      expect(
        UnderwritingLoanServices::CalculateDebtToIncome.sum_liability_payment(
          loan.properties
        )
      ).to eq(primary_property.liability_payments + first_property.liability_payments + second_property.liability_payments)
    end
  end

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
