require 'rails_helper'

describe DocumentUploaders::BorrowersController do
  include_context 'signed in as loan member user'

  before(:each) { @borrower = FactoryGirl.create(:borrower) }

  describe 'POST #upload' do
    it "uploads a new document" do
      post :upload, borrower_id: @borrower.id,
                    type: 'FirstBankStatement',
                    file: File.new(Rails.root.join 'spec', 'files', 'sample.pdf'),
                    format: :json

      @borrower.reload
      expect(@borrower.first_bank_statement).not_to be_nil
    end

    it 'renders necessary response' do
      post :upload, borrower_id: @borrower.id,
                    type: 'FirstBankStatement',
                    file: File.new(Rails.root.join 'spec', 'files', 'sample.pdf'),
                    format: :json
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(parsed_body['message']).to eq('Uploaded sucessfully')
      expect(parsed_body['download_url']).not_to be_blank
      expect(parsed_body['remove_url']).not_to be_blank
    end
  end
end
