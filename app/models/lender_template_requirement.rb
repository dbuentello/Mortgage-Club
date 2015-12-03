class LenderTemplateRequirement < ActiveRecord::Base
  belongs_to :lender
  belongs_to :lender_template

  validates :lender_id, :lender_template_id, presence: true
end
