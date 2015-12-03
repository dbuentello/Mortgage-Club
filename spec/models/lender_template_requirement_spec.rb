require "rails_helper"

describe LenderTemplateRequirement do
  it { should belong_to(:lender_template) }
  it { should belong_to(:lender) }
end
