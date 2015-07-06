class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  #  :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :lockable, :timeoutable, :confirmable

  has_many :loans, inverse_of: :user, dependent: :destroy
  has_many :templates, inverse_of: :creator
  has_many :signers, inverse_of: :user

  has_one :borrower, inverse_of: :user, autosave: :true, dependent: :destroy

  accepts_nested_attributes_for :borrower, allow_destroy: true

  delegate :first_name, :first_name=, to: :borrower, allow_nil: true
  delegate :last_name, :last_name=, to: :borrower, allow_nil: true

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

  def to_s
    "#{first_name} #{last_name}"
  end
end
