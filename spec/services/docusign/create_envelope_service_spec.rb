require "rails_helper"

describe Docusign::CreateEnvelopeService do
  let(:user) { FactoryGirl.create(:user) }
  let(:loan) { FactoryGirl.create(:loan_with_all_associations) }
  let(:template) { FactoryGirl.create(:template) }

  it "creates an envelope from Docusign successfully" do
    VCR.use_cassette("create an envelope from Docusign") do
      envelope_response = Docusign::CreateEnvelopeService.new(user, loan, template).call
      expect(envelope_response).to include(
        "envelopeId",
        "uri",
        "statusDateTime",
        "status"
      )
    end
  end

  it 'saves an envelope to database' do
    VCR.use_cassette("create an envelope from Docusign") do
      Docusign::CreateEnvelopeService.new(user, loan, template).call
      expect(Envelope.count).to eq(1)
    end
  end
end
