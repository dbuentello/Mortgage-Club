require 'rails_helper'

describe Users::LoansController do
  include_context 'signed in as borrower user of loan'
  let!(:not_permission_loan) { FactoryGirl.create(:loan) }
  let(:other_user) { FactoryGirl.create(:borrower_user_with_borrower) }
  let!(:credit_report) { FactoryGirl.create(:credit_report, borrower: loan.borrower) }

  before do
    not_permission_loan.user = other_user
  end

  describe 'POST #create' do
    context "when current user does not have any loans" do
      it 'assigns the requested loan to @loan' do
        expect { post :create, format: :json }.to change{Loan.count}.by(1)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user has permission to edit' do
      it 'shows passed id loan' do
        get :edit, id: loan.id

        expect(assigns(:loan)).to eq(loan)
        expect(response.status).to eq 200
      end
    end

    context 'when user does not have permission to edit loan' do
      it 'responds 403' do
        get :edit, id: not_permission_loan.id
        expect(response.status).to eq 403
      end
    end
  end

  describe 'PUT #update' do
    context 'when user can update his loan' do
      it 'updates a loan and assigns loan to @loan' do
        put :update, id: loan.id, loan: FactoryGirl.attributes_for(:loan), format: :json
        expect(assigns(:loan)).to eq(loan)
      end
    end

    context 'when user cannot update the other user loan' do
      it 'responds with status 403' do
        put :update, id: not_permission_loan.id, loan: FactoryGirl.attributes_for(:loan), format: :json
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user has permission to delete a loan' do
      it 'destroys passed id loan' do
        expect { delete :destroy, id: loan.id, format: :json }.to change { Loan.count }.by(-1)
      end
    end

    context 'when user access other user loan' do
      it 'does not allow a user delete the loan' do
        expect { delete :destroy, id: not_permission_loan.id, format: :json }.to change { Loan.count }.by(0)
      end

      it 'returns status 403' do
        delete :destroy, id: not_permission_loan.id, format: :json
        expect(response.status).to eq 403
      end
    end
  end
end
