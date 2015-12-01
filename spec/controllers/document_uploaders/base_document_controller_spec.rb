require 'rails_helper'

describe DocumentUploaders::BaseDocumentController do
  include_context 'signed in as loan member user'
  let!(:document) { FactoryGirl.create(:borrower_document) }

  describe 'DELETE #remove' do
    it "removes document successfully" do
      delete :remove, id: document.id, format: :json

      expect(Document.count).to eq(0)
    end
  end

  describe 'GET #download' do
    it "calls DocumentServices::DownloadFile service" do
      allow(DocumentServices::DownloadFile).to receive(:call).and_return('http://google.com')
      expect(DocumentServices::DownloadFile).to receive(:call)

      get :download, id: document.id, format: :json
    end

    it "redirects to AWS's URL" do
      allow(DocumentServices::DownloadFile).to receive(:call).and_return('http://google.com')

      get :download, id: document.id, format: :json

      expect(response.status).to eq(302)
    end
  end
end
