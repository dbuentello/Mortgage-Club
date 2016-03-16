require "rails_helper"

describe Docusign::MapEnvelopeToLenderDocument do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:lender_template) { FactoryGirl.create(:lender_template) }
  let!(:lender_template_requirement) { FactoryGirl.create(:lender_template_requirement, lender: loan.lender, lender_template: lender_template) }
  let(:user) { FactoryGirl.create(:user) }

  let(:envelope_id) { "53390977-43b7-4f5a-97dc-56e572002567" }

  context "with missing envelope's id" do
    it "returns false" do
      expect(described_class.new("", user.id, loan).call).to be_falsey
    end
  end

  context "with missing loan" do
    it "returns false" do
      expect(described_class.new(@envelope_id, user.id, nil).call).to be_falsey
    end
  end

  context "with missing lender" do
    it "returns false" do
      loan.update(lender: nil)
      expect(described_class.new(@envelope_id, user.id, loan).call).to be_falsey
    end
  end

  context "with valid params" do
    # Cannot simulate fake file: invalid content type

    # before(:each) do
    #   loan.lender_documents.destroy_all
    #   FileUtils.mkdir_p(Rails.root.join("spec", "files"))
    #   File.open("#{Rails.root}/tmp/docusign.pdf", "wb") do |output|
    #     output << "lorem ipsum"
    #   end
    #   allow(Docusign::DownloadDocumentService).to receive(:call).and_return("#{Rails.root}/tmp/docusign.pdf")
    # end

    # it "creates a new document" do
    #   service = described_class.new(@envelope_id, user.id, loan)
    #   # expect { service.call }.to change { LenderDocument.count }.from(0).to(1)
    # end
  end
end
