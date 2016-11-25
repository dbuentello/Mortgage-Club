class ActivityType < ActiveRecord::Base
  validates :label, presence: true

  has_many :loan_activities, dependent: :destroy
  has_many :activity_names, dependent: :destroy
end
