require "rails_helper"

describe RatesController do

  include_context "signed in as borrower user of loan"

  before(:each) {
    loan.primary_property.update(property_type: 'sfh')
    address = FactoryGirl.build(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: loan.primary_property.id)
    address.save
  }

  describe "GET index" do
    it "show list rate" do
      allow_any_instance_of(ZillowService::GetMortgageRates).to receive(:call).and_return([{"lender_name": "Sebonic Financial", "nmls": "66247", "website": "https://www.securecontactpage.com/sebonic-financial/1", "apr": 3.38, "monthly_payment": 2294, "loan_amount": 400000, "interest_rate": 3.375, "product": "20 year fixed", "total_fee": 1395, "fees": {"Loan origination fee": 895, "Appraisal fee": 500}, "down_payment": 100000}])
      allow(controller).to receive(:get_debug_info).and_return(nil)

      get :index, :loan_id => loan.id
      expect(response.status).to eq(200)
      expect(assigns(:bootstrap_data)[:rates][0][:lender_name]).to eq('Sebonic Financial')
    end

    it "not found rate" do
      allow_any_instance_of(ZillowService::GetMortgageRates).to receive(:call).and_return([])
      allow(controller).to receive(:get_debug_info).and_return(nil)
      get :index, :loan_id => loan.id
      expect(response.status).to eq(200)
      expect(assigns(:bootstrap_data)[:rates]).to eq([])
    end
  end

end
