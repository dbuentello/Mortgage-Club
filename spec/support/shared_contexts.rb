RSpec.shared_context 'anonymous user' do
end

RSpec.shared_context 'signed in borrower user' do
  let(:user) { FactoryGirl.create :borrower_user }
  before { login_with user }
end

RSpec.shared_context 'signed in loan member user' do
  let(:user) { FactoryGirl.create :loan_member_user }
  before { login_with user }
end

RSpec.shared_context 'signed in borrower user of loan' do
  let(:loan) { FactoryGirl.create :loan }
  before { login_with loan.user }
end