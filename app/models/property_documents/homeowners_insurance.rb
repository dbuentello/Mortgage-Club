# == Schema Information
#
# Table name: property_documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :integer
#  description             :string
#  created_at              :datetime
#  updated_at              :datetime
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#

class HomeownersInsurance < PropertyDocument
  DESCRIPTION = "Homeowner's insurance"

  belongs_to :property, inverse_of: :appraisal_report, foreign_key: 'owner_id'
end
