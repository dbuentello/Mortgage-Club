class Envelope < ActiveRecord::Base
  has_many :documents, inverse_of: :envelope, class_name: "Documents::EnvelopeDoc", dependent: :destroy

  has_many :signers, inverse_of: :envelope

  belongs_to :loan, inverse_of: :envelope
  belongs_to :template, inverse_of: :envelopes

end
