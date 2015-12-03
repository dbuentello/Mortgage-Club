require "rails_helper"

describe LenderTemplateRequirement do
  it { should belong_to(:lender_template) }
  it { should belong_to(:lender) }
  it { should validate_presence_of(:lender_template_id) }
  it { should validate_presence_of(:lender_id) }
end