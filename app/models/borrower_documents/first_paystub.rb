# == Schema Information
#
# Table name: borrower_documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :uuid
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#  description             :string
#  owner_type              :string
#  borrower_id             :uuid
#

class FirstPaystub < BorrowerDocument
  DESCRIPTION = "Paystub - Most recent month"

  belongs_to :borrower, inverse_of: :first_paystub, touch: true
  belongs_to :owner, polymorphic: true
end
