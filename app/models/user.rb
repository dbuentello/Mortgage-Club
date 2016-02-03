# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
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
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  token                  :string
#  first_name             :string
#  last_name              :string
#  middle_name            :string
#  suffix                 :string
#

class User < ActiveRecord::Base
  rolify

  # Include default devise modules. Others available are:
  #  :omniauthable
  devise :database_authenticatable, :async, :registerable, :recoverable, :rememberable,
    :trackable, :validatable, :lockable, :timeoutable, :confirmable

  has_many :loans, inverse_of: :user, dependent: :destroy
  has_many :templates, inverse_of: :creator
  has_many :signers, inverse_of: :user

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

  has_one :borrower, inverse_of: :user, autosave: :true, dependent: :destroy
  has_one :loan_member, inverse_of: :user, autosave: :true, dependent: :destroy
  has_many :borrower_documents, as: :owner

  has_many :documents
  has_many :checklists, dependent: :destroy

  has_attached_file :avatar, path: PAPERCLIP[:default_path], default_url: ActionController::Base.helpers.asset_path('avatar.png')

  accepts_nested_attributes_for :borrower, allow_destroy: true

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }

  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  validates :token, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  before_validation :set_private_token

  PERMITTED_ATTRS = [
    :first_name,
    :last_name,
    :middle_name,
    :suffix,
    :email,
    :password,
    :password_confirmation,
    :avatar
  ]

  def to_s
    "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def borrower?
    self.has_role? :borrower
  end

  def loan_member?
    self.has_role? :loan_member
  end

  def admin?
    self.has_role? :admin
  end

  def role_name
    roles.pluck(:name).join(", ") unless roles.empty?
  end

  def avatar_url
    avatar.url if avatar
  end

  private

  def set_private_token
    self.token ||= Digest::MD5.hexdigest(Time.now.utc.to_s)
  end
end
