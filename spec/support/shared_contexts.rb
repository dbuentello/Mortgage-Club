RSpec.shared_context 'anonymous user' do
end

RSpec.shared_context 'signed in user' do
  let(:user) { FactoryGirl.create :user }
  before { login_with user }
end

RSpec.shared_context 'signed in user of loan' do
  let(:loan) { FactoryGirl.create :loan }
  before { login_with loan.user }
end