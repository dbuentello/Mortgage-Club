class Signer < ActiveRecord::Base
  belongs_to :envelope, inverse_of: :signers
  belongs_to :user, inverse_of: :signers

  validates_presence_of :envelope_id, :user_id, :recipient_id
end
