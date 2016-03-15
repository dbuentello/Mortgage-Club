require 'rails_helper'

describe PotentialRateDropUsersController do
  let!(:potential_rate_drop_user) { FactoryGirl.attributes_for(:potential_rate_drop_user) }

  describe "#create" do
    context "with valid params" do
      it "creates new record" do
        expect{ post :create, potential_rate_drop_user, format: :json}.to change(PotentialRateDropUser, :count).by 1
      end

      it "return a success message" do
        post :create, potential_rate_drop_user
        expect(JSON.parse(response.body)["message"]).to eq("success")
      end
    end
  end
end
