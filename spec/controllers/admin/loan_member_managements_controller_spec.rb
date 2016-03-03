require "rails_helper"

describe Admins::LoanMemberManagementsController do
  include_context "signed in as admin"

  describe "#create" do
    context "when valid params" do
      let(:loan_member_params) { FactoryGirl.attributes_for(:loan_member).merge({first_name: "Jon", last_name: "Smith", email: Faker::Internet.email, password: "secret-password"}) }
      it "returns successful message" do
        post :create, loan_member: loan_member_params
        expect(JSON.parse(response.body)["message"]).to eq("Created sucessfully")
      end
      it "changes LoanMember data table by 1" do
        expect{post :create, loan_member: loan_member_params }.to change(LoanMember, :count).by 1
      end
    end
  end
end