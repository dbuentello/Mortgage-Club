require "rails_helper"

describe Docusign::MapChecklistExplanationToLenderDocument do
  let(:lender_template) { FactoryGirl.create(:lender_template_with_docusign) }
  let(:checklist) { FactoryGirl.create(:checklist_explain, template: lender_template.template) }
  let!(:lender_template_requirement) { FactoryGirl.create(:lender_template_requirement, lender: checklist.loan.lender, lender_template: lender_template) }
  let!(:document) { FactoryGirl.create(:lender_document, loan: checklist.loan, lender_template: lender_template) }

  before(:each) { @envelope_id = "53390977-43b7-4f5a-97dc-56e572002567" }

  context "with valid params" do
    it "updates a lender document" do
      VCR.use_cassette("download envelope from Docusign for checklist's explanation") do
        checklist.loan.lender_documents.destroy_all
        service = described_class.new(@envelope_id, checklist.id, checklist.loan.user.id)
        expect { service.call }.to change { checklist.loan.lender_documents.count }.by(1)
      end
    end
  end

  context "with missing envelope id" do
    it "returns false" do
      expect(described_class.new(nil, checklist.id, checklist.loan.user.id).call).to be_falsey
    end
  end

  context "with invalid checklist" do
    it "returns false" do
      expect(described_class.new(@envelope_id, "fake-id", checklist.loan.user.id).call).to be_falsey
    end
  end

  context "with missing checklist's template" do
    it "returns false" do
      checklist.update(template: nil)
      expect(described_class.new(@envelope_id, checklist.id, checklist.loan.user.id).call).to be_falsey
    end
  end
end
