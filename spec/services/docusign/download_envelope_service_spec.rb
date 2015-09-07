require 'rails_helper'

describe Docusign::DownloadEnvelopeService do
  before(:each) do
    @envelope_id = 'f2916f5a-f290-44ed-887a-5a3ec29ffe72'
  end

  it "downloads an envelope from Docusign successfully" do
    VCR.use_cassette("download envelope from Docusign") do
      file_path = Docusign::DownloadEnvelopeService.call(@envelope_id)
      expect(file_path).not_to be_nil
    end
  end
end