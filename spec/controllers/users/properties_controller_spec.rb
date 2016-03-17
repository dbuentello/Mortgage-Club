require "rails_helper"

describe Users::PropertiesController do
  include_context "signed in as borrower user of loan"

  let(:borrower) do
    loan.borrower.create_credit_report
    loan.borrower
  end
  let(:primary_property) { FactoryGirl.create(:property, property_type: "sfh", loan: loan) }
  let!(:first_address) { FactoryGirl.create(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: loan.primary_property.id) }
  let(:property) { FactoryGirl.create(:rental_property, property_type: "condo", loan_id: loan.id) }
  let!(:second_address) { FactoryGirl.create(:address, street_address: "209 Silver Eagle Road", city: "Sacramento", zip: 95839, property_id: property.id) }

  describe "#destroy" do
    context "when property is valid" do
      it "returns success" do
        delete :destroy, id: property.id
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["message"]).to eq("ok")
      end
    end

    context "when property is invalid" do
      it "returns failure" do
        delete :destroy, id: "invalid-property"
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["message"]).to eq("error")
      end
    end
  end

  describe "#search" do
    it "search with valid address" do
      search_params = {address: '4400 Forest Parkway', citystatezip: 'Sacramento, CA 95823'}
      get :search, search_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['zestimate']).not_to be_nil
    end

    it "search with invalid address" do
      search_params = {address: 'this-is-a-invalid-address', citystatezip: 'this-is-a-invalid-city-zip'}
      get :search, search_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['zestimate']).to be_nil
    end
  end
end
