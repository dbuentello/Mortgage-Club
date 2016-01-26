require "rails_helper"

RSpec.describe UnderwritingController do
  include_context "signed in as borrower user of loan"

  before(:each) {
    loan.subject_property.update(property_type: 'sfh')
    address = FactoryGirl.build(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: loan.subject_property.id)
    address.save
  }
  it "responds with code 200 when loan is completed" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(true)
      get :index, :loan_id => loan.id
      expect(response.status).to eq(200)
    end

    it "redirects to the loan edit page when the loan uncompleted" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(false)

      get :index, :loan_id => loan.id
      expect(response.status).to eq(302)
    end
end