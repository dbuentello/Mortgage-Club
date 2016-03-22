class HomepageRate < ActiveRecord::Base
  validates :lender_name, presence: true
  validates :program, presence: true
  validates :display_time, presence: true

  PERMITTED_ATTRS = [
    :lender_name,
    :program,
    :rate_value,
    :display_time
  ]

  scope :today_rates, -> { where("updated_at >= ?", Time.zone.now.beginning_of_day) }
end
