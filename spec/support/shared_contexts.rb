RSpec.shared_context 'anonymous user' do
end

RSpec.shared_context 'signed in user' do
  let(:user) { FactoryGirl.create :user }
  before { sign_in user }
end