require 'rails_helper'

describe LoanActivityServices::SetUserVisibleToFalse do
  let(:loan_activity) { FactoryGirl.create(:loan_activity, name: "Verify borrower's income") }
  before(:each) do
    @the_same_loan_activity = FactoryGirl.create(
      :loan_activity,
      loan: loan_activity.loan, activity_type: loan_activity.activity_type,
      name: loan_activity.name, user_visible: true
    )
    @the_another_loan_activity = FactoryGirl.create(:loan_activity, name: "Order preliminary title report", user_visible: true)
    LoanActivityServices::SetUserVisibleToFalse.call(loan_activity.loan, loan_activity.name)
  end

  it "updates all the same activity's user_visible to false" do
    @the_same_loan_activity.reload
    expect(@the_same_loan_activity.user_visible).to eq(false)
  end

  it "does not update the another activity's user_visible to false" do
    @the_another_loan_activity.reload
    expect(@the_same_loan_activity.user_visible).not_to eq(false)
  end
end