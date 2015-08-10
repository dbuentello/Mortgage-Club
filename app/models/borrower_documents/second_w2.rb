# == Schema Information
#
# Table name: borrower_documents
#
#  id                      :integer          not null, primary key
#  type                    :string
#  owner_id                :integer
#  attachment_file_name    :string
#  attachment_content_type :string
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  token                   :string
#  description             :string
#  owner_type              :string
#  borrower_id             :integer
#

class SecondW2 < BorrowerDocument
  DESCRIPTION = "W2 - Previous tax year"

  belongs_to :borrower, inverse_of: :second_w2
end
