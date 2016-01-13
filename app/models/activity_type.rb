class ActivityType < ActiveRecord::Base
  validates :label, presence: true
  validates :type_name_mapping, presence: true
end
