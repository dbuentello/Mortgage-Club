require "rails_helper"

describe Admins::LoanMemberManagementsController do
  include_context "signed in as admin"

  describe "#create" do
    context "when valid params" do
      before do
        @loan_member_params = {
          first_name: "Jon",
          last_name: "Smith",
          email: Faker::Internet.email,
          password: "secret-password",
          company_name: "Green Valley",
          company_address: "Sillicon Valley",
          company_phone_number: "(134)-345-678",
          company_nmls: "33883",
          nmls_id: "334545"
        }
      end
      it "returns successful message" do
        post :create, loan_member: @loan_member_params
        expect(JSON.parse(response.body)["message"]).to eq("Created sucessfully")
      end
      it "changes User data table by 1" do
        expect { post :create, loan_member: @loan_member_params }.to change(User, :count).by 1
      end
      it "changes LoanMember data table by 1" do
        expect { post :create, loan_member: @loan_member_params }.to change(LoanMember, :count).by 1
      end
    end
  end
end
