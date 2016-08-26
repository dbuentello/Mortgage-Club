class ActivityType < ActiveRecord::Base
  validates :label, presence: true

  has_many :loan_activities
  has_many :activity_names
end
