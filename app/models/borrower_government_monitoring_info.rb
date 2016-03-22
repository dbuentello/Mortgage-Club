# == Schema Information
#
# Table name: borrower_government_monitoring_infos
#
#  id                    :uuid             not null, primary key
#  borrower_id           :uuid
#  is_hispanic_or_latino :boolean
#  gender_type           :integer
#

class BorrowerGovernmentMonitoringInfo < ActiveRecord::Base
  belongs_to :borrower, inverse_of: :borrower_government_monitoring_info, foreign_key: 'borrower_id'
  has_many :borrower_races, inverse_of: :borrower_government_monitoring_info, dependent: :destroy
  accepts_nested_attributes_for :borrower_races, allow_destroy: true

  PERMITTED_ATTRS = [
    :is_hispanic_or_latino,
    :gender_type,
    borrower_races_attributes: [:id] + BorrowerRace::PERMITTED_ATTRS
  ]

  enum gender_type: {
    male: 0,
    female: 1
  }
end
