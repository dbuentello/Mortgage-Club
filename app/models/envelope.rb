class Envelope < ActiveRecord::Base
  has_many :documents, inverse_of: :envelope, class_name: "Documents::Envelope", dependent: :destroy

  # has_many :envelopes_users
  # has_many :signers, through: :envelopes_users, class_name: "User"

  belongs_to :loan, inverse_of: :envelope
  belongs_to :template, inverse_of: :envelopes

end
