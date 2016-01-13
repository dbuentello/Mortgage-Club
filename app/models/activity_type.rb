class ActivityType < ActiveRecord::Base
  validates :label, presence: true
  validates :type_name_mapping, presence: true

  has_many :loan_activities
end
