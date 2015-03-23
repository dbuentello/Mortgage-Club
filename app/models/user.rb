class User < ActiveRecord::Base
  has_secure_password

  has_many :loans, inverse_of: :user, dependent: :destroy
  has_one :borrower, inverse_of: :user, autosave: :true, dependent: :destroy

  before_create :build_borrower

  delegate :first_name, to: :borrower, allow_nil: true
  delegate :last_name, to: :borrower, allow_nil: true

  validates :email,
            presence: true,
            uniqueness: true,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
            }

  PERMITTED_ATTRS = [
    :email,
    :password,
    :password_confirmation,
    borrower_attributes: [:id] + Borrower::PERMITTED_ATTRS
  ]

  def first_name=(name)
    build_borrower unless self.borrower.present?
    borrower.first_name = name
  end

  def last_name=(name)
    build_borrower unless self.borrower.present?
    borrower.last_name = name
  end

  def to_s
    "#{first_name} #{last_name}"
  end
end
