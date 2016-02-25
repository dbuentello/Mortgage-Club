class LoanMembersTitle < ActiveRecord::Base
  before_validation { |title| title.title = title.title.titleize if title.title }
  has_many :loans_members_associations, dependent: :destroy
  validates :title, presence: true
end