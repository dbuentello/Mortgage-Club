require "rails_helper"

describe Users::UnderwritingController do
  include_context "signed in as borrower user of loan"

  let!(:subject_property) { FactoryGirl.create(:property, loan: loan, property_type: "sfh") }
  let!(:address) { FactoryGirl.create(:address, street_address: "208 Silver Eagle Road", city: "Sacramento", zip: 95838, property_id: subject_property.id) }

  describe "#index" do
    it "responds with code 200 when loan is completed" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(true)

      get :index, loan_id: loan.id
      expect(response.status).to eq(200)
    end

    it "redirects to the loan edit page when the loan uncompleted" do
      allow_any_instance_of(Loan).to receive("completed?").and_return(false)

      get :index, loan_id: loan.id
      expect(response.status).to eq(302)
    end
  end

  describe "#check_loan" do
    it "renders message ok when loan is valid" do
      allow_any_instance_of(UnderwritingLoanServices::UnderwriteLoan).to receive("valid_loan?").and_return(true)

      get :check_loan, loan_id: loan.id
      expect(JSON.parse(response.body)["message"]).to eq "ok"
    end

    it "renders message error when loan is invalid" do
      allow_any_instance_of(UnderwritingLoanServices::UnderwriteLoan).to receive("valid_loan?").and_return(false)

      get :check_loan, loan_id: loan.id
      expect(JSON.parse(response.body)["message"]).to eq "error"
    end
  end
end
