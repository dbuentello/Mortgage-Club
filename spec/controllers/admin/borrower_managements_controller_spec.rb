require "rails_helper"

describe Admins::BorrowerManagementsController do
  include_context "signed in as admin"

  describe "#destroy" do
    context "when valid params" do
      let!(:borrower) { FactoryGirl.create(:borrower, :with_user)}

      it "returns successful message" do
        delete :destroy, id: borrower.id
        expect(response.status).to eq(200)
      end

    end
  end
end
