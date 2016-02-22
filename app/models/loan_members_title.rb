class LoanMembersTitle < ActiveRecord::Base
  has_many :loans_members_associations, dependent: :destroy
  validates :title, presence: true
end