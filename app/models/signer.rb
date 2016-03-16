# == Schema Information
#
# Table name: signers
#
#  id           :integer          not null, primary key
#  role_name    :string
#  recipient_id :uuid
#  envelope_id  :uuid
#  user_id      :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Signer < ActiveRecord::Base
  belongs_to :envelope, inverse_of: :signers
  belongs_to :user, inverse_of: :signers

  validates :envelope_id, :user_id, :recipient_id, presence: true
end
