require "rails_helper"

describe Docusign::GetRecipientViewService do
  context "with valid envelope" do
    it "returns a recipient view from Docusign" do
      envelope_id = "015d6d82-116c-4faf-a02f-9f80043c01a2"
      user = double(to_s: "Tri Pham", email: "borrower@gmail.com")
      view = Docusign::GetRecipientViewService.call(envelope_id, user, "https://google.com")
      expect(view).to include("url")
    end
  end

  context "with invalid recipient's info" do
    it "returns nil" do
      envelope_id = "015d6d82-116c-4faf-a02f-9f80043c01a2"
      user = double(to_s: "Tang Nguyen", email: "borrower@gmail.com")
      view = Docusign::GetRecipientViewService.call(envelope_id, user, "https://google.com")
      expect(view).to be_nil
    end
  end
end
