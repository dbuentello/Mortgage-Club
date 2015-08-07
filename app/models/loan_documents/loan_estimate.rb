# == Schema Information
#
# Table name: loan_documents
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
#  loan_id                 :integer
#

class LoanEstimate < LoanDocument
  DESCRIPTION = "Loan estimate"

  belongs_to :loan, inverse_of: :hud_estimate, foreign_key: 'loan_id'
  belongs_to :owner, polymorphic: true
end
