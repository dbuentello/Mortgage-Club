require "rails_helper"

describe Admins::BorrowerManagementsController do
  include_context "signed in as admin"

  describe "#destroy" do
    context "when params are valid" do
      let!(:borrower) { FactoryGirl.create(:borrower, :with_user) }

      it "returns status 200" do
        delete :destroy, id: borrower.id
        expect(response.status).to eq(200)
      end

      it "returns array of borrower" do
        expectation = {
          borrowers: []
        }.to_json
        delete :destroy, id: borrower.id
        expect(response.body).to eq(expectation)
      end
    end

    context "when params are invalid" do
      let!(:borrower) { FactoryGirl.create(:borrower, :with_user) }

      it "returns status 500" do
        allow_any_instance_of(Borrower).to receive(:destroy_completely).and_return(false)
        delete :destroy, id: borrower.id
        expect(response.status).to eq(500)
      end
    end
  end
end
