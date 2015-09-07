require "rails_helper"
include Rails.application.routes.url_helpers

describe Docusign::GetRecipientViewService do
  context "valid envelope" do
    it "returns a recipient view from Docusign" do
      envelope_id = '5d46fa35-35ac-4b44-9e28-a72b81582523'
      user = double(to_s: 'John Doe', email: 'borrower@gmail.com')
      view = Docusign::GetRecipientViewService.call(envelope_id, user, 'https://google.com')
      expect(view).to include("url")
    end
  end

  context "invalid recipient's info" do
    it "returns an error" do
      envelope_id = '5d46fa35-35ac-4b44-9e28-a72b81582523'
      user = double(to_s: 'John Doe', email: 'faker@gmail.com')
      view = Docusign::GetRecipientViewService.call(envelope_id, user, 'https://google.com')
      expect(view).to include("errorCode")
    end
  end
end
