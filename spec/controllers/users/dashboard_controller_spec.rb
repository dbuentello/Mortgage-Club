require "rails_helper"

describe Users::DashboardController do
  include_context "signed in as borrower user of loan"

  describe "#show" do
    context "with new loan" do
      let!(:loan) { FactoryGirl.create(:loan) }

      it "redirect to edit page" do
        get :show, id: loan.id
        expect(response.status).to eq 302
      end
    end

    context "with completed loan" do
      let!(:loan) { FactoryGirl.create(:loan_with_all_associations, status: :submitted) }

      it "shows loan information correctly" do
        loan.update(status: :submitted)
        get :show, id: loan.id
        expect(response.status).to eq 200
      end
    end
  end
end