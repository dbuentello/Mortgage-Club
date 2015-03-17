class BorrowerGovernmentInfo < ActiveRecord::Base
  belongs_to :borrower
  has_many   :borrower_races, dependent: :destroy
  accepts_nested_attributes_for :borrower_races, allow_destroy: true

  PERMITTED_ATTRS = [
    :hispanic_or_latino,
    :gender_type,
    borrower_races_attributes: [:id] + BorrowerRace::PERMITTED_ATTRS,
  ]

  enum gender_type: {
    male: 0,
    female: 1
  }
end