require 'rails_helper'

describe LoansController do 
  describe 'GET #index' do
    it 'populates an array of loans' do
      loan = FactoryGirl.create(:loan)
      get :index, format: :json
      expect(assigns(:loans)).to eq([loan])
    end
  end

  describe 'GET #show' do 
    it 'assigns the requested loan to @loan' do
      loan = FactoryGirl.create(:loan)
      get :show, id: loan.id, format: :json
      expect(assigns(:loan)).to eq(loan)
    end
  end

  describe 'POST #create' do
    it 'creates a new loan and assigns loan to @loan' do
      post :create, record: FactoryGirl.attributes_for(:loan), format: :json
      expect(Loan.count).to eq(1)
    end
  end

  describe 'PUT #update' do
    it 'updates a loan and assigns loan to @loan' do
      loan = FactoryGirl.create(:loan)
      put :update, id: loan.id, record: FactoryGirl.attributes_for(:loan), format: :json
      expect(assigns(:loan)).to eq(loan)
    end
  end
end
