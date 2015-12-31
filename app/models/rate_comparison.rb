class RateComparison < ActiveRecord::Base
  serialize :rates

  belongs_to :loan

  validates :loan_id, presence: :true
  validates :competitor_name, presence: :true
end
