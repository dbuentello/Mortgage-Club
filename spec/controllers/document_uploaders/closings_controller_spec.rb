require 'rails_helper'

describe DocumentUploaders::ClosingsController do
  include_context 'signed in as loan member user'

  before(:each) do
    @closing = FactoryGirl.create(:closing)
    file = File.new(Rails.root.join 'spec', 'files', 'sample.pdf')
    @uploaded_file = ActionDispatch::Http::UploadedFile.new(
      tempfile: file,
      filename: File.basename(file),
    )
    @uploaded_file.content_type = 'application/pdf' # it's so weird
  end

  describe 'POST #upload' do
    it "uploads a new document" do
      post :upload, closing_id: @closing.id,
                    type: 'ClosingDisclosure',
                    file: @uploaded_file,
                    format: :json

      @closing.reload
      expect(@closing.closing_disclosure).not_to be_nil
    end

    it 'renders necessary response' do
      post :upload, closing_id: @closing.id,
                    type: 'ClosingDisclosure',
                    file: @uploaded_file,
                    format: :json
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(parsed_body['message']).to eq('Uploaded sucessfully')
      expect(parsed_body['download_url']).not_to be_blank
      expect(parsed_body['remove_url']).not_to be_blank
    end
  end
end
