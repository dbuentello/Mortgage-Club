require "rails_helper"

describe Users::RatesController do

  include_context "signed in as borrower user of loan"

  before(:each) {
    loan.subject_property.update(property_type: "sfh")
    address = FactoryGirl.build(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: loan.subject_property.id)
    address.save
  }

  describe "GET #index" do
    it "shows list quotes when the loan completed" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(true)
      allow_any_instance_of(LoanTekServices::GetQuotes).to receive(:call).and_return([{"lender_name": "Sebonic Financial", "nmls": "66247", "apr": 3.38, "monthly_payment": 2294, "loan_amount": 400000, "interest_rate": 3.375, "product": "20 year fixed", "total_fee": 1395, "down_payment": 100000}])

      get :index, :loan_id => loan.id
      expect(response.status).to eq(200)
      expect(assigns(:bootstrap_data)[:programs][0][:lender_name]).to eq("Sebonic Financial")
    end

    it "shows redirect to the loan edit page when the loan uncompleted" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(false)
      allow_any_instance_of(LoanTekServices::GetQuotes).to receive(:call).and_return([{"lender_name": "Sebonic Financial", "nmls": "66247", "apr": 3.38, "monthly_payment": 2294, "loan_amount": 400000, "interest_rate": 3.375, "product": "20 year fixed", "total_fee": 1395, "down_payment": 100000}])

      get :index, :loan_id => loan.id
      expect(response.status).to eq(302)
    end

    it "does not find quotes" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(true)
      allow_any_instance_of(LoanTekServices::GetQuotes).to receive(:call).and_return([])

      get :index, :loan_id => loan.id
      expect(response.status).to eq(200)
      expect(assigns(:bootstrap_data)[:programs]).to eq([])
    end
  end
end
