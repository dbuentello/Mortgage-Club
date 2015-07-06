class Template < ActiveRecord::Base
  belongs_to :creator, inverse_of: :templates, class_name: "User", foreign_key: 'creator_id'

  has_many :envelopes, inverse_of: :template

  validates_presence_of :name, :docusign_id, :state
  validates :name, uniqueness: true

end
