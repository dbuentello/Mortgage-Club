# == Schema Information
#
# Table name: templates
#
#  id            :integer          not null, primary key
#  name          :string
#  state         :string
#  description   :string
#  email_subject :string
#  email_body    :string
#  docusign_id   :string
#  creator_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Template < ActiveRecord::Base
  belongs_to :creator, inverse_of: :templates, class_name: "User", foreign_key: 'creator_id'

  has_many :envelopes, inverse_of: :template

  validates_presence_of :name, :docusign_id, :state
  validates :name, uniqueness: true

end
