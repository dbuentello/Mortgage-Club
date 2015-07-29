require 'rails_helper'

describe PagesController do
  describe "GET index" do
    it "allows guest to view" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET take_home_test" do
    it "allows guest to view" do
      get :take_home_test
      expect(response.status).to eq(200)
    end
  end
end
