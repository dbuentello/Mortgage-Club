# == Schema Information
#
# Table name: templates
#
#  id            :uuid             not null, primary key
#  name          :string
#  state         :string
#  description   :string
#  email_subject :string
#  email_body    :string
#  docusign_id   :string
#  creator_id    :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

describe Template do
  it { should have_many(:envelopes) }
  it { should have_many(:lender_templates) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:template)).to be_valid
  end
end
