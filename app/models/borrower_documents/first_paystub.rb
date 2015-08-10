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

class FirstPaystub < BorrowerDocument
  DESCRIPTION = "Paystub - Most recent month"

  belongs_to :borrower, inverse_of: :first_paystub, class_name: 'Borrower', foreign_key: 'owner_id'
end
