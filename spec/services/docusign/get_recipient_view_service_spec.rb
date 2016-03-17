require "rails_helper"
include Rails.application.routes.url_helpers

describe Docusign::GetRecipientViewService do
  context "with valid envelope" do
    it "returns a recipient view from Docusign" do
      envelope_id = "851f0a7b-5159-4f72-beec-241da3db1ec7"
      user = double(to_s: "Tri Pham", email: "borrower@gmail.com")
      view = Docusign::GetRecipientViewService.call(envelope_id, user, "https://google.com")
      expect(view).to include("url")
    end
  end

  context "with invalid recipient's info" do
    it "returns nil" do
      envelope_id = "851f0a7b-5159-4f72-beec-241da3db1ec7"
      user = double(to_s: "Tang Nguyen", email: "borrower@gmail.com")
      view = Docusign::GetRecipientViewService.call(envelope_id, user, "https://google.com")
      expect(view).to be_nil
    end
  end
end
