class LoanMembersTitle < ActiveRecord::Base
  before_validation :titleize_title
  has_many :loans_members_associations, dependent: :destroy
  validates :title, presence: true

  private

  def titleize_title
    self.title = self.title.titleize if self.title
  end
end