require 'rails_helper'

describe LoanPropertyController do 
  describe "GET #show" do 
    it "assigns the requested property to @property" do
      loan = FactoryGirl.create(:loan)
      property = loan.property
      get :show, loan_id: loan.id, format: :json
      expect(assigns(:loan_property)).to eq(property)
    end
  end
end
