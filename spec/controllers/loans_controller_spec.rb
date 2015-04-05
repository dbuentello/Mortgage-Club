require 'rails_helper'

describe LoansController do 
  describe 'GET #show' do 
    it 'assigns the requested loan to @loan' do
      loan = FactoryGirl.create(:loan)
      login_with loan.user
      get :show, id: loan.id, format: :json
      expect(assigns(:loan)).to eq(loan)
    end
  end

  describe 'POST #create' do
    it 'creates a new loan and assigns loan to @loan' do
      post :create, loan: FactoryGirl.attributes_for(:loan), format: :json
      expect(Loan.count).to eq(1)
    end
  end

  describe 'PUT #update' do
    it 'updates a loan and assigns loan to @loan' do
      loan = FactoryGirl.create(:loan)
      login_with loan.user
      put :update, id: loan.id, loan: FactoryGirl.attributes_for(:loan), format: :json
      expect(assigns(:loan)).to eq(loan)
    end
  end
end
