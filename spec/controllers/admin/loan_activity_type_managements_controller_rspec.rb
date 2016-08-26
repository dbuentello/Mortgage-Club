require "rails_helper"

describe Admins::LoanActivityTypeManagementsController do
  include_context "signed in as admin"

  let!(:activity_type) { FactoryGirl.create(:activity_type) }

  describe "#index" do
    it "assigns the requested @activity_types to bootstrap activity_types" do
      get :index
      expect(assigns(:bootstrap_data)[:activity_types].length).to eq(1)
    end

    it "renders the :admin_app template" do
      get :index
      expect(response).to render_template :admin_app
    end
  end

  describe "#destroy" do
    it "destroys passed id activity_type" do
      delete :destroy, id: activity_type.id, format: :json
      expect(ActivityType.count).to eq(0)
    end
  end

  describe "#create" do
    it "saves the new activity_type in the database" do
      expect { post :create, activity_type: attributes_for(:activity_type, label: "label") }.to change(ActivityType, :count).by(1)
    end

    it "assigns the requested activity_type to @activity_type" do
      post :create, activity_type: attributes_for(:activity_type, label: "label")
      expect(assigns(:activity_type).label).to eq("label")
    end

    it "renders error message with empty label" do
      post :create, activity_type: attributes_for(:activity_type, label: nil)
      expect(JSON.parse(response.body)["message"]).to include("can't be blank")
    end
  end

  describe "#edit" do
    it "assigns the requested activity_type to bootstrap activity_type" do
      get :edit, id: activity_type.id
      expect(assigns(:bootstrap_data)[:activity_type]["label"]).to eq("label")
    end

    it "renders the :admin_app template" do
      get :edit, id: activity_type.id
      expect(response).to render_template :admin_app
    end
  end

  describe "#update" do
    it "updates activity_type in the database" do
      patch :update, id: activity_type.id, activity_type: attributes_for(:activity_type, label: "label")
      expect(JSON.parse(response.body)["message"]).to include("Updated sucessfully")
    end
  end
end
