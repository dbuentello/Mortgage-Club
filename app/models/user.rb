# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#

class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  #  :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :lockable, :timeoutable, :confirmable

  has_many :loans, inverse_of: :user, dependent: :destroy
  has_many :templates, inverse_of: :creator
  has_many :signers, inverse_of: :user

  has_one :borrower, inverse_of: :user, autosave: :true, dependent: :destroy
  has_one :team_member, inverse_of: :user, autosave: :true, dependent: :destroy

  has_one :appraisal_report, as: :owner, dependent: :destroy
  has_one :homeowners_insurance, as: :owner, dependent: :destroy
  has_one :mortgage_statement, as: :owner, dependent: :destroy
  has_one :lease_agreement, as: :owner, dependent: :destroy
  has_one :purchase_agreement, as: :owner, dependent: :destroy
  has_one :flood_zone_certification, as: :owner, dependent: :destroy
  has_one :termite_report, as: :owner, dependent: :destroy
  has_one :inspection_report, as: :owner, dependent: :destroy
  has_one :title_report, as: :owner, dependent: :destroy
  has_one :risk_report, as: :owner, dependent: :destroy

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
