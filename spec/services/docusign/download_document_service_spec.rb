require "rails_helper"

describe Docusign::DownloadDocumentService do
  it "downloads an envelope from Docusign successfully" do
    envelope_id = "53390977-43b7-4f5a-97dc-56e572002567"
    VCR.use_cassette("download envelope from Docusign") do
      file_path = described_class.call(envelope_id, "Loan Estimate", 1)
      expect(file_path).not_to be_nil
    end
  end
end
