# == Schema Information
#
# Table name: lender_templates
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  is_other    :boolean          default(FALSE)
#  template_id :uuid
#

require "rails_helper"

describe LenderTemplate do
  it { should have_many(:lender_template_requirements) }
  it { should have_many(:lenders) }
  it { should belong_to(:template) }
  it { should validate_presence_of(:name) }

  it "has a valid factory" do
    expect(FactoryGirl.build(:lender_template)).to be_valid
  end
end
