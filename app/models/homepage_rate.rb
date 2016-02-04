class HomepageRate < ActiveRecord::Base
  validates :lender_name, presence: true
  validates :rate_value, presence: true
  validates :program, presence: true
end