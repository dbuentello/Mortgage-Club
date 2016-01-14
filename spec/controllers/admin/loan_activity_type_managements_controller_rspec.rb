require "rails_helper"

describe Admins::LoanActivityTypeManagementsController do
  include_context "signed in as admin"

  let!(:activity_type) { FactoryGirl.create(:activity_type) }

  describe "GET #index" do
    it "assigns the requested @activity_types to bootstrap activity_types" do
      get :index
      expect(assigns(:bootstrap_data)[:activity_types].length).to eq(1)
    end

    it "renders the :admin_app template" do
      get :index
      expect(response).to render_template :admin_app
    end
  end

  describe "DELETE #destroy" do
    it "destroys passed id activity_type" do
      delete :destroy, id: activity_type.id, format: :json
      expect(ActivityType.count).to eq(0)
    end
  end

  describe "POST #create" do
    it "saves the new activity_type in the database" do
      expect { post :create, activity_type: attributes_for(:activity_type, label: "label", type_name_mapping: ["name 1", "name 2"]) }.to change(ActivityType, :count).by(1)
    end

    it "assigns the requested activity_type to @activity_type" do
      post :create, activity_type: attributes_for(:activity_type, label: "label", type_name_mapping: ["name 1", "name 2"])
      expect(assigns(:activity_type).label).to eq("label")
    end

    it "renders error message with empty label" do
      post :create, activity_type: attributes_for(:activity_type, label: nil, type_name_mapping: ["name 1", "name 2"])
      expect(JSON.parse(response.body)["message"]).to include("can't be blank")
    end

    it "renders error message with empty type_name_mapping" do
      post :create, activity_type: attributes_for(:activity_type, label: "label", type_name_mapping: nil)
      expect(JSON.parse(response.body)["message"]).to include("can't be blank")
    end
  end

  describe "GET #edit" do
    it "assigns the requested activity_type to bootstrap activity_type" do
      get :edit, id: activity_type.id
      expect(assigns(:bootstrap_data)[:activity_type]["label"]).to eq("label")
    end

    it "renders the :admin_app template" do
      get :edit, id: activity_type.id
      expect(response).to render_template :admin_app
    end
  end

  describe "PATCH #update" do
    it "updates activity_type in the database" do
      patch :update, id: activity_type.id, activity_type: attributes_for(:activity_type, label: "label", type_name_mapping: ["name 1", "name 2"])
      expect(JSON.parse(response.body)["message"]).to include("Updated sucessfully")
    end

    it "renders error message with empty type_name_mapping" do
      patch :update, id: activity_type.id, activity_type: attributes_for(:activity_type, label: "label", type_name_mapping: [])
      expect(JSON.parse(response.body)["message"]).to include("Updated failed")
    end
  end
end
