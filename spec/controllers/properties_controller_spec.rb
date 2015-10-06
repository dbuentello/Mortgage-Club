require "rails_helper"

describe PropertiesController do
  include_context "signed in as borrower user of loan"
  before(:each) {
    @property = FactoryGirl.build(:property, property_type: 'sfh', is_primary: true, loan_id: loan.id)
    @property.save
    address = FactoryGirl.build(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: @property.id)
    address.save
  }

  describe "POST #create" do
    it "update primary property" do
      params = {loan_id: loan.id, own_investment_property: true, primary_property: FactoryGirl.attributes_for(:primary_property), rental_properties: []}
      post :create, params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['loan']).not_to eq(nil)
    end
  end

  describe "DELETE #destroy" do
    it "remove a property" do
      delete :destroy, id: @property.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('ok')
    end
  end

end