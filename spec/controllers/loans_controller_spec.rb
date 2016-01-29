require 'rails_helper'

describe Users::LoansController do
  include_context 'signed in as borrower user of loan'
  let!(:not_permission_loan) { FactoryGirl.create(:loan) }
  let(:other_user) { FactoryGirl.create(:borrower_user_with_borrower) }
  let!(:credit_report) { FactoryGirl.create(:credit_report, borrower: loan.borrower)}

  before do
    not_permission_loan.user = other_user
  end

  describe 'POST #create' do
    it 'assigns the requested loan to @loan' do
      expect { post :create, format: :json }.to change{Loan.count}.by(1)
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
      it 'responses 403' do
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
        expect { delete :destroy, id: loan.id, format: :json }.to change{Loan.count}.by(-1)
      end
    end

    context 'when user access other user loan' do
      it 'does not allow a user delete the loan' do
        expect { delete :destroy, id: not_permission_loan.id, format: :json }.to change{Loan.count}.by(0)
      end

      it 'returns status 403' do
        delete :destroy, id: not_permission_loan.id, format: :json
        expect(response.status).to eq 403
      end
    end
  end

  # disable it temporarily
  # describe 'GET #get_secondary_borrower_info' do
  #   it "returns warning when email hasn't been existed" do
  #     get :get_secondary_borrower_info, id: loan.id, email: "random_email@abc.com", format: :json

  #     expect(JSON.parse(response.body)["message"]).to eq('Not found')
  #   end

  #   it "returns warning when co-borrower info is not correct" do
  #     params = {
  #       id: loan.id,
  #       email: other_user.email,
  #       ssn: "32323232"
  #     }

  #     get :get_secondary_borrower_info, params, format: :json
  #     expect(JSON.parse(response.body)["message"]).to eq('Invalid email or date of birth or social security number')
  #   end

  #   it "returns warning when co-borrower info is enough" do
  #     params = {
  #       id: loan.id,
  #       email: other_user.email,
  #       dob: other_user.borrower.dob
  #     }

  #     get :get_secondary_borrower_info, params, format: :json
  #     expect(JSON.parse(response.body)["message"]).to eq('Invalid email or date of birth or social security number')
  #   end

  #   it "returns full co-borrower data when email, dob and ssn number are correct" do
  #     params = {
  #       id: loan.id,
  #       email: other_user.email,
  #       dob: other_user.borrower.dob,
  #       ssn: other_user.borrower.ssn
  #     }

  #     get :get_secondary_borrower_info, params, format: :json
  #     expect(JSON.parse(response.body)["secondary_borrower"]).to be_truthy
  #   end
  # end
end
