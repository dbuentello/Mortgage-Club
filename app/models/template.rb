class Template < ActiveRecord::Base
  belongs_to :creator, inverse_of: :templates, class_name: "User", foreign_key: 'creator_id'

  has_namy :envelopes, inverse_of: :template

end
