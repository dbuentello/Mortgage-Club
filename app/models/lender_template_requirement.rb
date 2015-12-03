class LenderTemplateRequirement < ActiveRecord::Base
  belongs_to :lender
  belongs_to :lender_template
end
