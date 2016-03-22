require "rails_helper"

describe Users::ChecklistsController do
  include_context "signed in as borrower user of loan"

  let(:checklist) { FactoryGirl.create(:checklist_explain, loan: loan) }
  let(:user) { FactoryGirl.create(:user) }

  describe ".update" do
    context "with valid attributes" do
      it "updates a checklist" do
        put :update, id: checklist.id, checklist: FactoryGirl.attributes_for(:checklist), format: :json
        expect(assigns(:checklist)).to eq(checklist)
      end
    end

    context "with invalid attributes" do
      it "raises an error" do
        put :update, id: checklist.id, checklist: FactoryGirl.attributes_for(:checklist, checklist_type: nil), format: :json
        expect(response.body).to eq("{\"message\":\"Cannot update the checklist\"}")
      end
    end
  end

  describe ".load_docusign" do
    context "with valid template" do
      it "calls Docusign::CreateEnvelopeForChecklistService" do
        allow(Docusign::GetRecipientViewService).to receive(:call).and_return("")
        allow_any_instance_of(Docusign::CreateEnvelopeForChecklistService).to receive(:call).and_return("")
        expect_any_instance_of(Docusign::CreateEnvelopeForChecklistService).to receive(:call)

        get :load_docusign, id: checklist.id, template_name: checklist.template.name, loan_id: checklist.loan.id
      end
    end

    context "with invalid template" do
      it "raises an error" do
        get :load_docusign, id: checklist.id, template_name: "", loan_id: checklist.loan.id
        expect(response.body).to eq("{\"message\":\"Template is not found\",\"details\":\"Template  does not exist yet!\"}")
      end
    end
  end

  describe ".docusign_callback" do
    context "when signing complete" do
      it "updates checklist's status to done" do
        allow_any_instance_of(Docusign::MapChecklistExplanationToLenderDocument).to receive(:call)
        get :docusign_callback, event: "signing_complete", id: checklist.id, loan_id: checklist.loan.id, envelope_id: "an-envelope-id", user_id: user.id
        checklist.reload
        expect(checklist.status).to eq('done')
      end

      it "calls Docusign::UploadEnvelopeToAmazonService" do
        allow_any_instance_of(Docusign::MapChecklistExplanationToLenderDocument).to receive(:call)
        get :docusign_callback, event: "signing_complete", id: checklist.id, loan_id: checklist.loan.id, envelope_id: "an-envelope-id", user_id: user.id
        expect(Delayed::Job.count).to eq(1)
      end
    end
  end
end
