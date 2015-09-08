class Invite < ActiveRecord::Base
  before_create :generate_token

  belongs_to :user
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }

  def generate_token
     self.token = Digest::SHA1.hexdigest([self.sender_id, Time.now, rand].join)
  end
 end