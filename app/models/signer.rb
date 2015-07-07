# == Schema Information
#
# Table name: signers
#
#  id           :integer          not null, primary key
#  role_name    :string
#  recipient_id :integer
#  envelope_id  :integer
#  user_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Signer < ActiveRecord::Base
  belongs_to :envelope, inverse_of: :signers
  belongs_to :user, inverse_of: :signers

  validates_presence_of :envelope_id, :user_id, :recipient_id
end
