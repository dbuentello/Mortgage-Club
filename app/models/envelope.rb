# == Schema Information
#
# Table name: envelopes
#
#  id          :uuid             not null, primary key
#  docusign_id :string
#  template_id :uuid
#  loan_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Envelope < ActiveRecord::Base
  # Note: we don't need these associations for now due to local storage solution
  # has_many :documents, inverse_of: :envelope, class_name: "Documents::EnvelopeDoc", foreign_key: "owner_id", dependent: :destroy
  # has_many :signers, inverse_of: :envelope

  belongs_to :loan, inverse_of: :envelope
  belongs_to :template, inverse_of: :envelopes

  has_one :user, through: :loan

  validates :docusign_id, :template_id, :loan_id, presence: true

end
