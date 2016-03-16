require "rails_helper"
include Rails.application.routes.url_helpers

describe Docusign::GetRecipientViewService do
  context "with valid envelope" do
    it "returns a recipient view from Docusign" do
      # wait for new envelope id

      # envelope_id = 'bd396f16-4b9b-449f-8be9-c8c5b95ac1b3'
      # user = double(to_s: 'John Doe', email: 'borrower@gmail.com')
      # view = Docusign::GetRecipientViewService.call(envelope_id, user, 'https://google.com')
      # expect(view).to include("url")
    end
  end

  context "with invalid recipient's info" do
    it "returns nil" do
      envelope_id = 'bd396f16-4b9b-449f-8be9-c8c5b95ac1b3'
      user = double(to_s: 'John Doe', email: 'faker@gmail.com')
      view = Docusign::GetRecipientViewService.call(envelope_id, user, 'https://google.com')
      expect(view).to be_nil
    end
  end
end
