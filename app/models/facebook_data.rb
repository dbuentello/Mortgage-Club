class FacebookData < ActiveRecord::Base
  validates :conversation_id, :first_name, :last_name, presence: true
end
