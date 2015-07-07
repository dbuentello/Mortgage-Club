# == Schema Information
#
# Table name: envelopes
#
#  id          :integer          not null, primary key
#  docusign_id :string
#  template_id :integer
#  loan_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Envelope < ActiveRecord::Base
  has_many :documents, inverse_of: :envelope, class_name: "Documents::EnvelopeDoc",
   foreign_key: "owner_id", dependent: :destroy

  has_many :signers, inverse_of: :envelope

  belongs_to :loan, inverse_of: :envelope
  belongs_to :template, inverse_of: :envelopes

  validates_presence_of :docusign_id, :template_id, :loan_id

end
