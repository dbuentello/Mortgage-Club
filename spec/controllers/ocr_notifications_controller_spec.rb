require 'rails_helper'

describe OcrNotificationsController do
  describe "POST receive" do
    it "alway render nothing" do
      post :receive
      expect(response.status).to eq(200)
    end
  end
end
