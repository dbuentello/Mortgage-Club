require "rails_helper"

describe SubmissionServices::GetEmailInfo do
  let(:loan) { FactoryGirl.create(:loan) }
  let(:staff) { FactoryGirl.create(:user) }
  let(:loan_member) { FactoryGirl.create(:loan_member, user: staff) }
  let!(:loans_members_association) { FactoryGirl.create(:loans_members_association, loan: loan, loan_member: loan_member) }
  let!(:lender_document) { FactoryGirl.create(:lender_document, loan: loan) }

  context "with valid params" do
    it "returns an email's info" do
      expect(described_class.new(loan, loan_member, staff).call).to include({
        templates_name: loan.lender.lender_templates.where(is_other: false).pluck(:description),
        lender_name: loan.lender.name,
        lender_email: loan.lender.lock_rate_email,
        loan_member_name: staff.to_s,
        client_name: loan.borrower.user.to_s,
        loan_member_title: loan_member.title(loan),
        loan_member_email: "#{staff} <#{staff.email}>",
        loan_member_short_email: staff.email,
        loan_member_phone_number: loan_member.phone_number,
        loan_id: loan.id
      })
    end
  end

  context "with invalid params" do
    it "returns nil" do
      expect(described_class.new(nil, nil, nil).call).to be_nil
    end
  end
end
