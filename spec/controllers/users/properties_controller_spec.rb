require "rails_helper"

describe Users::PropertiesController do
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

  context 'when property is valid' do
    it {
      delete :destroy, id: @property.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('ok')
    }
  end

  context 'when property is invalid' do
    it {
      delete :destroy, id: 'invalid-property'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['message']).to eq('error')
    }
  end

  describe "#search" do
    it "seach with valid address" do
      search_params = {address: '4400 Forest Parkway', citystatezip: 'Sacramento, CA 95823'}
      get :search, search_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['zestimate']).not_to be_nil
    end

    it "seach with invalid address" do
      search_params = {address: 'this-is-a-invalid-address', citystatezip: 'this-is-a-invalid-city-zip'}
      get :search, search_params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['zestimate']).to be_nil
    end
  end
end