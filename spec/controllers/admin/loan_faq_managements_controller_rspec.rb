require "rails_helper"

describe Admins::LoanFaqManagementsController do
  include_context "signed in as admin"

  let!(:faq) { FactoryGirl.create(:faq) }

  describe "GET #index" do
    it "assigns the requested faqs to bootstrap faqs" do
      get :index
      expect(assigns(:bootstrap_data)[:faqs].length).to eq(1)
    end

    it "renders the :admin_app template" do
      get :index
      expect(response).to render_template :admin_app
    end
  end

  describe "DELETE #destroy" do
    it "destroys passed id faq" do
      delete :destroy, id: faq.id, format: :json
      expect(Faq.count).to eq(0)
    end
  end

  describe "POST #create" do
    it "saves the new faq in the database" do
      expect { post :create, faq: attributes_for(:faq, question: "question", answer: "<p>answer</p>") }.to change(Faq, :count).by(1)
    end

    it "assigns the requested faq to @faq" do
      post :create, faq: attributes_for(:faq, question: "question", answer: "<p>answer</p>")
      expect(assigns(:faq).question).to eq("question")
    end

    it "renders error message with empty question" do
      post :create, faq: attributes_for(:faq, question: nil, answer: "<p>answer</p>")
      expect(JSON.parse(response.body)["message"]).to include("can't be blank")
    end

    it "renders error message with empty answer" do
      post :create, faq: attributes_for(:faq, question: "question", answer: nil)
      expect(JSON.parse(response.body)["message"]).to include("can't be blank")
    end
  end

  describe "GET #edit" do
    it "assigns the requested faqs to bootstrap faq" do
      get :edit, id: faq.id
      expect(assigns(:bootstrap_data)[:faq]["question"]).to eq("What is the question?")
    end

    it "renders the :admin_app template" do
      get :edit, id: faq.id
      expect(response).to render_template :admin_app
    end
  end

  describe "PATCH #update" do
    it "updates faq in the database" do
      patch :update, id: faq.id, faq: attributes_for(:faq, question: "question", answer: "answer")
      expect(JSON.parse(response.body)["message"]).to include("Updated sucessfully")
    end

    it "renders error message with empty answer" do
      patch :update, id: faq.id, faq: attributes_for(:faq, question: "question", answer: nil)
      expect(JSON.parse(response.body)["message"]).to include("Updated failed")
    end
  end
end
