require "rails_helper"

describe BorrowerServices::RemoveSecondaryBorrower do

  describe "the method for removing secondary borrower for a loan" do
    let!(:loan) { FactoryGirl.create(:loan_with_all_associations) }

    it "calls save method for borrower that will be removed" do
      expect_any_instance_of(Borrower).to receive(:save).and_return true
      BorrowerServices::RemoveSecondaryBorrower.call(loan.user, loan, :secondary_borrower)
    end

    it "removes the secondary user correctly" do
      @user = loan.borrower
      BorrowerServices::RemoveSecondaryBorrower.call(loan.user, loan, :secondary_borrower)
      expect(@user.loan).to eq nil
    end
  end
end
