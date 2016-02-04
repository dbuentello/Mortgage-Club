class HomepageRate < ActiveRecord::Base
  validates :lender_name, presence: true
  validates :program, presence: true

  PERMITTED_ATTRS = [
    :lender_name,
    :program,
    :rate_value
  ]
  scope :today_rates, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }
end