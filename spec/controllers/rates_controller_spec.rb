require "rails_helper"

describe RatesController do
  include_context "signed in as borrower user of loan"
  before(:each) {
    property = FactoryGirl.build(:property, property_type: 'sfh', is_primary: true, loan_id: loan.id)
    property.save
    address = FactoryGirl.build(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: property.id)
    address.save
  }

  describe "GET index" do
    it "show list rate" do
      get :index, :loan_id => loan.id
      expect(response.status).to eq(200)
    end
  end

end