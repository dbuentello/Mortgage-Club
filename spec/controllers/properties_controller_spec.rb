require "rails_helper"

describe PropertiesController do

  include_context "signed in as borrower user of loan"
  before(:each) {
    loan.primary_property.update(property_type: 'sfh')
    loan.borrower.create_credit_report
    address = FactoryGirl.build(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: loan.primary_property.id)
    address.save

    @property = FactoryGirl.build(:rental_property, property_type: 'condo', loan_id: loan.id)
    @property.save
    address = FactoryGirl.build(:address, street_address: "209 Silver Eagle Road", city: "Sacramento", zip: 95839, property_id: @property.id)
    address.save
  }

  describe "POST #create" do
    it "update primary property" do
      params = {loan_id: loan.id, own_investment_property: true, primary_property: FactoryGirl.attributes_for(:primary_property), rental_properties: []}
      post :create, params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['loan']).not_to eq(nil)
      expect(JSON.parse(response.body)['loan']['rental_properties'].size).to eq(1)
    end
  end

  describe "DELETE #destroy" do
    it "remove a valid property" do
      delete :destroy, id: @property.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('ok')
    end

    it "remove a invalid property" do
      delete :destroy, id: 'invalid-property'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('error')
    end
  end

  describe "GET #search" do
    it "seach with valid address" do
      search_params = {address: 'Schenectady', citystatezip: 'Schenectady NY 12302'}
      get :search, search_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['zestimate']).not_to eq(nil)
    end

    it "seach with invalid address" do
      search_params = {address: 'this-is-a-invalid-address', citystatezip: 'this-is-a-invalid-city-zip'}
      get :search, search_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['zestimate']).to eq(nil)
    end
  end

end