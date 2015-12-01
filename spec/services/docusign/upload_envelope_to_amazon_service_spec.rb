require 'rails_helper'

describe Docusign::UploadEnvelopeToAmazonService do
  let(:checklist) { FactoryGirl.create(:checklist_explain, document_type: 'first_bank_statement') }
  let(:borrower) { FactoryGirl.create(:borrower, loan: checklist.loan) }
  let!(:document) { FactoryGirl.create(:borrower_document, subjectable: borrower) }

  before(:each) do
    @envelope_id = 'f2916f5a-f290-44ed-887a-5a3ec29ffe72'
    @service = Docusign::UploadEnvelopeToAmazonService.new(@envelope_id, checklist.id, checklist.loan.user.id)
  end

  context "valid params" do
    it "calls DownloadEnvelopeService" do
      VCR.use_cassette("download envelope from Docusign") do
        expect(Docusign::DownloadEnvelopeService).to receive(:call).with(@envelope_id)
        @service.call
      end
    end

    it "calls DocumentServices::UploadFile" do
      allow(Docusign::DownloadEnvelopeService).to receive(:call).and_return(Rails.root.join 'spec', 'files', 'sample.doc')
      allow(File).to receive(:delete).and_return(true)
      expect_any_instance_of(DocumentServices::UploadFile).to receive(:call)
      @service.call
    end
  end
end