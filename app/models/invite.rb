class Invite < ActiveRecord::Base
  before_create :generate_token
  before_save :check_user_existence

  belongs_to :user
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    }


  def check_user_existence
    recipient = User.find_by(email: email)
   if recipient
      self.recipient_id = recipient.id
   end
  end

  def generate_token
     self.token = Digest::SHA1.hexdigest([self.sender_id, Time.zone.now, rand].join)
  end

end