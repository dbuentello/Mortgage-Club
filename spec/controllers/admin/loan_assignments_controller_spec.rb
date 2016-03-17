require 'rails_helper'

describe Admins::LoanAssignmentsController do
  include_context 'signed in as admin'

  let(:loan) { FactoryGirl.create(:loan) }
  let(:loan_member) { FactoryGirl.create(:loan_member) }
  let(:loans_members_association) { FactoryGirl.create(:loans_members_association, loan: loan) }
  let(:loan_with_loan_member) { FactoryGirl.create(:loan_with_loan_member) }

  describe '#create' do
    it 'assigns the requested loan to @loan' do
      post :create, loan_id: loan.id, loan_member_id: loan_member.id, title: 'sale', format: :json
      expect(LoansMembersAssociation.count).to eq(1)
    end
  end

  describe '#destroy' do
    it 'destroys passed id loan' do
      delete :destroy, id: loans_members_association.id, loan_id: loan.id, format: :json
      expect(LoansMembersAssociation.count).to eq(0)
    end
  end

  describe '#loan_members' do
    it 'returns associations between loan and members' do
      get :loan_members, loan_id: loan_with_loan_member.id, format: :json
      expect(JSON.parse(response.body)['associations']).not_to be_empty
    end
  end
end
