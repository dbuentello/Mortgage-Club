class Envelope < ActiveRecord::Base
  has_many :documents, inverse_of: :envelope

  # has_many :envelopes_users
  # has_many :signers, through: :envelopes_users, class_name: "User"

  belongs_to :loan
  belongs_to :template

end
