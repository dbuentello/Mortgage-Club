require "rails_helper"

describe Users::DashboardController do
  include_context "signed in as borrower user of loan"

  describe "#show" do
    context "when new loan" do
      let!(:loan) { FactoryGirl.create(:loan) }

      it "redirects to edit page" do
        get :show, id: loan.id
        expect(response.status).to eq(302)
      end
    end

    context "when completed loan" do
      let!(:loan) { FactoryGirl.create(:loan_with_all_associations, status: :submitted) }

      it "renders template borrower_app" do
        get :show, id: loan.id
        expect(response).to render_template("borrower_app")
      end
    end

    context "when the loan that not belongs to the current user" do
      before do
        @loan = FactoryGirl.create(:loan_with_all_associations)
      end

      it "cannot access the loan" do
        get :show, id: @loan.id
        expect(response.status).to eq(403)
      end
    end
  end
end
