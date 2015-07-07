# == Schema Information
#
# Table name: documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :integer
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#

class Documents::EnvelopeDoc < Document
  # NOTE: someday when more class has documents inside, we should use polymorphic approuch instead
  belongs_to :envelope, inverse_of: :documents, class_name: "Envelope", foreign_key: 'owner_id'

end
