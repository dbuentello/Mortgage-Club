require "rails_helper"

describe BorrowerServices::AssignSecondaryBorrowerToLoan do
  before do
    @secondary_params =  {
      borrower: {
        first_name: "John",
        last_name: "Smith",
        middle_name: "Manh",
        suffix: "Mr",
        email: "cuong@gmail.com",
        password: "this-is-password",
        password_confirmation: "this-is-password"
      }
    }
  end


  describe "the method for assigning secondary borrower for a loan" do
    let!(:loan) { FactoryGirl.create(:loan_with_all_associations) }

    it "calls save params" do
      expect_any_instance_of(Loan).to receive(:save).and_return true
      BorrowerServices::AssignSecondaryBorrowerToLoan.new(loan, @secondary_params, nil).call
    end
  end
end
