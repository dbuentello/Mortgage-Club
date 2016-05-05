require "rails_helper"

describe LoanMemberServices::UpdateLoanTermsServices do
  describe ".update_loan" do
    context "with un available subject property data" do
      let!(:loan) { FactoryGirl.create(:loan) }
      let(:property_params) { {estimated_property_tax: 12, estimated_hazard_insurance: 11, estimated_mortgage_insurance: 3, estimated_mortgage_balance: 6} }
      let(:loan_terms_params) { {amount: 999} }
      let(:address_params) { {zip: "92802", city: "Anaheim", state: "CA", full_text: "666 Disneyland Drive, Anaheim, CA 92802", street_address: "666 Disneyland Drive"} }

      it "creates subject property if subject property not available" do
        expect { described_class.new(loan.id, nil, nil, loan_terms_params, property_params, nil).update_loan }.to change(Property, :count).by(1)
      end

      it "creates subject property's address" do
        expect { described_class.new(loan.id, nil, nil, loan_terms_params, property_params, address_params).update_loan }.to change(Address, :count).by(1)
      end
    end

    context "with availale subject property" do
      let!(:loan) { FactoryGirl.create(:loan) }
      let!(:property) { FactoryGirl.create(:property, loan_id: loan.id, is_subject: true)}
      let!(:address) { FactoryGirl.create(:address, property_id: property.id) }

      let(:property_params) { {estimated_property_tax: 12, estimated_hazard_insurance: 11, estimated_mortgage_insurance: 3, estimated_mortgage_balance: 6} }
      let(:loan_terms_params) { {amount: 999} }
      let(:address_params) { {zip: "92802", city: "Anaheim", state: "CA", full_text: "666 Disneyland Drive, Anaheim, CA 92802", street_address: "666 Disneyland Drive"} }

      it "updates subject property data" do
        described_class.new(loan.id, property.id, nil, loan_terms_params, property_params, nil).update_loan
        property.reload
        expect(property.estimated_property_tax).to eq(12)
        expect(property.estimated_mortgage_balance).to eq(6)
      end

      it "updates subject property data" do
        described_class.new(loan.id, property.id, nil, loan_terms_params, property_params, nil).update_loan
        property.reload
        expect(property.estimated_property_tax).to eq(12)
        expect(property.estimated_mortgage_balance).to eq(6)
      end

      it "updates address of subject property" do
        described_class.new(loan.id, property.id, address.id, loan_terms_params, property_params, address_params).update_loan
        address.reload
        expect(address.zip).to eq("92802")
      end
    end
  end
end
