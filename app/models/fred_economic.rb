class FredEconomic < ActiveRecord::Base
  validates :event_date, presence: true
end
