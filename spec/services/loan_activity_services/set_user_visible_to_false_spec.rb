require 'rails_helper'

describe LoanActivityServices::SetUserVisibleToFalse do
  let(:loan_activity) { FactoryGirl.create(:loan_activity, name: "Verify borrower's income") }
  let!(:the_same_loan_activity) do
    FactoryGirl.create(
      :loan_activity,
      loan: loan_activity.loan, activity_type: loan_activity.activity_type,
      name: loan_activity.name, user_visible: true
    )
  end
  let!(:the_another_loan_activity) do
    FactoryGirl.create(
      :loan_activity,
      name: "Order preliminary title report",
      user_visible: true
    )
  end

  before(:each) do
    LoanActivityServices::SetUserVisibleToFalse.call(loan_activity.loan, loan_activity.name)
  end

  it "updates all the same activity's user_visible to false" do
    the_same_loan_activity.reload
    expect(the_same_loan_activity.user_visible).to be_falsey
  end

  it "does not update the another activity's user_visible to false" do
    the_another_loan_activity.reload
    expect(the_same_loan_activity.user_visible).not_to be_falsey
  end
end
