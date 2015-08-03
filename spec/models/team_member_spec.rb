require 'rails_helper'

describe TeamMember do
  it 'has 2 valid factories' do
    expect(FactoryGirl.create(:team_member)).to be_valid
    expect(FactoryGirl.create(:team_member_with_user)).to be_valid
  end
end
