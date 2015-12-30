class RateComparison < ActiveRecord::Base
  serialize :rates

  belongs_to :loan
end
