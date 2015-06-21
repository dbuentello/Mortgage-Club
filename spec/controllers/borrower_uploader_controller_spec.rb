require 'rails_helper'

RSpec.describe BorrowerUploaderController, type: :controller do

  describe "GET #bank_statements" do
    it "returns http success" do
      get :bank_statements
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #brokerage_statements" do
    it "returns http success" do
      get :brokerage_statements
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #paystubs" do
    it "returns http success" do
      get :paystubs
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #w2s" do
    it "returns http success" do
      get :w2s
      expect(response).to have_http_status(:success)
    end
  end

end
