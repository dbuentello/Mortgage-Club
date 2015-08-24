RSpec.shared_context 'anonymous user' do
end

RSpec.shared_context 'signed in as borrower user' do
  let(:user) { FactoryGirl.create(:borrower_user_with_borrower) }
  before { login_with user }
end

RSpec.shared_context 'signed in as loan member user' do
  let(:user) { FactoryGirl.create(:loan_member_user_with_loan_member) }
  before { login_with user }
end

RSpec.shared_context 'signed in as borrower user of loan' do
  let(:loan) { FactoryGirl.create :loan_with_property }
  before { login_with loan.user }
end

RSpec.shared_context 'signed in as admin' do
  let(:user) { FactoryGirl.create(:admin) }
  before { login_with user }
end
