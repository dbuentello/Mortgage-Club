# == Schema Information
#
# Table name: property_documents
#
#  id                      :uuid             not null, primary key
#  type                    :string
#  owner_id                :uuid
#  description             :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#  owner_type              :string
#  property_id             :uuid
#

class OtherPropertyReport < PropertyDocument
  belongs_to :property, inverse_of: :other_property_report, foreign_key: 'property_id'
  belongs_to :owner, polymorphic: true
end
