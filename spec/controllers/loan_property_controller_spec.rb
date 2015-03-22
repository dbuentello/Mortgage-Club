require 'rails_helper'

describe LoanPropertyController do 
  describe 'GET #show' do 
    it 'assigns the requested property to @loan_property' do
      loan = FactoryGirl.create(:loan_with_property)
      get :show, loan_id: loan.id, format: :json
      expect(assigns(:loan_property)).to eq(loan.property)
    end
  end

  describe 'POST #create' do
    it 'creates a new property and assigns property to @loan_property' do
      loan = FactoryGirl.create(:loan)
      post :create, loan_id: loan.id, record: FactoryGirl.attributes_for(:property), format: :json
      expect(Property.count).to eq(1)
      expect(assigns(:loan_property)).to eq(loan.property)
    end
  end

  describe 'PUT #update' do
    it 'updates a property and assigns property to @loan_property' do
      loan = FactoryGirl.create(:loan_with_property)
      put :update, loan_id: loan.id, record: FactoryGirl.attributes_for(:property), format: :json
      expect(assigns(:loan_property)).to eq(loan.property)
    end
  end
end
