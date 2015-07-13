require 'rails_helper'

describe LoanBorrowerController do
  describe 'GET #show' do
    context 'primary borrower' do
      it 'assigns the requested borrower to @loan_borrower' do
        loan = FactoryGirl.create(:loan)
        get :show, loan_id: loan.id, format: :json
        expect(assigns(:loan_borrower)).to eq(loan.borrower)
      end
    end
    context 'secondary borrower' do
      it 'assigns the requested secondary borrower to @loan_borrower' do
        loan = FactoryGirl.create(:loan_with_secondary_borrower)
        get :show, loan_id: loan.id, type: 'is_secondary', format: :json
        expect(assigns(:loan_borrower)).to eq(loan.secondary_borrower)
      end
    end
  end

  describe 'POST #create' do
    context 'primary borrower' do
      it 'creates a new borrower and assigns borrower to @loan_borrower' do
        loan = FactoryGirl.create(:loan)
        post :create, loan_id: loan.id, record: FactoryGirl.attributes_for(:borrower), format: :json
        # user (already has borrower) -> loan -> create borrower
        expect(Borrower.count).to eq(2)
        expect(assigns(:loan_borrower)).to eq(loan.borrower)
      end
    end
    context 'secondary borrower' do
      it 'creates a new secondary borrower and assigns secondary borrower to @loan_borrower' do
        loan = FactoryGirl.create(:loan)
        post :create, loan_id: loan.id, record: FactoryGirl.attributes_for(:borrower), type: 'is_secondary', format: :json
        # user (already has borrower) -> loan -> create secondary borrower
        expect(Borrower.count).to eq(2)
        expect(assigns(:loan_borrower)).to eq(loan.secondary_borrower)
      end
    end
  end

  describe 'PUT #update' do
    context 'primary borrower' do
      it 'updates a borrower and assigns borrower to @loan_borrower' do
        loan = FactoryGirl.create(:loan)
        put :update, loan_id: loan.id, record: FactoryGirl.attributes_for(:borrower), format: :json
        expect(assigns(:loan_borrower)).to eq(loan.borrower)
      end
    end
    context 'secondary borrower' do
      it 'updates a secondary borrower and assigns secondary borrower to @loan_borrower' do
        loan = FactoryGirl.create(:loan_with_secondary_borrower)
        put :update, loan_id: loan.id, record: FactoryGirl.attributes_for(:borrower), type: 'is_secondary', format: :json
        expect(assigns(:loan_borrower)).to eq(loan.secondary_borrower)
      end
    end
  end
end
