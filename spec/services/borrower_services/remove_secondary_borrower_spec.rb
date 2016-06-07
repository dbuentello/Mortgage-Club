require "rails_helper"

describe BorrowerServices::RemoveSecondaryBorrower do
  describe ".call" do
    let!(:loan) { FactoryGirl.create(:loan_with_all_associations) }

    context "when current user as borrower" do
      it "removes the loan out of secondary borrower" do
        @user = loan.secondary_borrower
        BorrowerServices::RemoveSecondaryBorrower.call(loan.user, loan, :borrower)
        expect(@user.loan).to be_nil
      end

      it "removes the secondary borrower out of loan" do
        BorrowerServices::RemoveSecondaryBorrower.call(loan.user, loan, :borrower)
        expect(loan.secondary_borrower).to be_nil
      end
    end

    context "when current user as secondary_borrower" do
      it "removes the loan out of secondary borrower" do
        @user = loan.borrower
        BorrowerServices::RemoveSecondaryBorrower.call(loan.user, loan, :secondary_borrower)
        expect(@user.loan).to be_nil
      end

      it "removes the secondary borrower out of loan" do
        BorrowerServices::RemoveSecondaryBorrower.call(loan.user, loan, :secondary_borrower)
        expect(loan.secondary_borrower).to be_nil
      end
    end
  end
end
