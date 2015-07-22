require 'rails_helper'

describe LoansController do
  describe 'GET #new' do
    it 'assigns the requested loan to @loan' do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      get :new, id: loan.id, format: :html
      expect(assigns(:loan)).to eq(loan)
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
