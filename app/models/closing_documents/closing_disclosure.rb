# == Schema Information
#
# Table name: closing_documents
#
#  id                      :uuid             not null, primary key
#  type                    :string
#  owner_type              :string
#  owner_id                :uuid
#  description             :string
#  closing_id              :uuid
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#

class ClosingDisclosure < ClosingDocument
  DESCRIPTION = "Closing Disclosure"

  belongs_to :closing, inverse_of: :closing_disclosure, foreign_key: 'closing_id'
  belongs_to :owner, polymorphic: true

  def label_name
    DESCRIPTION
  end
end
