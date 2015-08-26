require 'rails_helper'

describe DocumentUploaders::BaseDocumentController do
  include_context 'signed in as loan member user'

  before(:each) { @second_w2 = FactoryGirl.create(:second_w2) }

  describe 'DELETE #remove' do
    it "removes document successfully" do
      delete :remove, id: @second_w2.id,
                    type: 'SecondW2',
                    format: :json

      expect(SecondW2.count).to eq(0)
    end
  end

  describe 'GET #download' do
    it "calls DocumentServices::DownloadFile service" do
      allow(DocumentServices::DownloadFile).to receive(:call).and_return('http://google.com')
      expect(DocumentServices::DownloadFile).to receive(:call)

      get :download, id: @second_w2.id,
                    type: 'SecondW2',
                    format: :json
    end

    it "redirects to AWS's URL" do
      allow(DocumentServices::DownloadFile).to receive(:call).and_return('http://google.com')

      get :download, id: @second_w2.id,
                    type: 'SecondW2',
                    format: :json

      expect(response.status).to eq(302)
    end
  end
end
