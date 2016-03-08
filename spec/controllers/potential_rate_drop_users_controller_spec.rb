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

    context "with invalid params" do
      it "returns error" do
        potential_rate_drop_user[:send_as_email] = nil
        potential_rate_drop_user[:send_as_text_message] = nil

        post :create, potential_rate_drop_user

        expect(JSON.parse(response.body)["alert_method"]).to eq("This field is required")
      end
    end
  end

end
