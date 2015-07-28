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

  describe 'GET #get_co_borrower_info' do
    it "should return warning when email hasn't been existed" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      get :get_co_borrower_info, id: loan.id, email: "random_email@abc.com", format: :json

      expect(JSON.parse(response.body)["message"]).to eq('Not found')
    end

    it "should return warning when co-borrower info is not correct" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      other_user = FactoryGirl.create(:user)
      params = {
        id: loan.id,
        email: other_user.email,
        ssn: "32323232"
      }

      get :get_co_borrower_info, params, format: :json
      expect(JSON.parse(response.body)["message"]).to eq('Invalid email or date of birth or social security number')
    end

    it "should return warning when co-borrower info is enough" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      other_user = FactoryGirl.create(:user)
      params = {
        id: loan.id,
        email: other_user.email,
        dob: other_user.borrower.dob
      }

      get :get_co_borrower_info, params, format: :json
      expect(JSON.parse(response.body)["message"]).to eq('Invalid email or date of birth or social security number')
    end

    it "should return full co-borrower data when email, dob and ssn number are correct" do
      loan = FactoryGirl.create(:loan)
      login_with loan.user

      other_user = FactoryGirl.create(:user)
      params = {
        id: loan.id,
        email: other_user.email,
        dob: other_user.borrower.dob,
        ssn: other_user.borrower.ssn
      }

      get :get_co_borrower_info, params, format: :json
      expect(JSON.parse(response.body)["secondary_borrower"]).to be_truthy
    end

  end
end
