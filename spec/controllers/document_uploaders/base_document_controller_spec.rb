require 'rails_helper'

describe DocumentUploaders::BaseDocumentController do
  include_context "signed in as loan member user"
  let!(:document) { FactoryGirl.create(:borrower_document) }

  describe "#destroy" do
    it "removes document successfully" do
      delete :destroy, id: document.id, format: :json

      expect(Document.count).to eq(0)
    end
  end

  describe "#download" do
    it "calls DocumentServices::DownloadFile service" do
      allow(Amazon::GetUrlService).to receive(:call).and_return("http://google.com")
      expect(Amazon::GetUrlService).to receive(:call)

      get :download, id: document.id, format: :json
    end

    it "redirects to AWS's URL" do
      allow(Amazon::GetUrlService).to receive(:call).and_return("http://google.com")

      get :download, id: document.id, format: :json

      expect(response).to redirect_to("http://google.com")
    end
  end
end
