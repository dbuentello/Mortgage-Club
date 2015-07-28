require 'rails_helper'

describe BorrowerUploaderController do
  # ignore GET download actions because they use aws methods, which is not available in test environment

  describe "POST w2" do
    it "should return warning when file is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      post :w2, id: 1, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('File not found')
    end
  end

  describe "POST paystub" do
    it "should return warning when file is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      post :paystub, id: 1, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('File not found')
    end
  end

  describe "POST paystub" do
    it "should return warning when file is blank" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      post :paystub, id: 1, format: :json

      expect(JSON.parse(response.body)["message"]).to eq('File not found')
    end
  end

end
