require 'rails_helper'

describe DocumentUploaders::LoansController do
  include_context 'signed in as loan member user'

  before(:each) { @loan = FactoryGirl.create(:loan) }

  describe 'POST #upload' do
    it "uploads a new document" do
      post :upload, loan_id: @loan.id,
                    type: 'HudEstimate',
                    file: File.new(Rails.root.join 'spec', 'files', 'sample.pdf'),
                    format: :json

      @loan.reload
      expect(@loan.hud_estimate).not_to be_nil
    end

    it 'renders necessary response' do
      post :upload, loan_id: @loan.id,
                    type: 'HudEstimate',
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
