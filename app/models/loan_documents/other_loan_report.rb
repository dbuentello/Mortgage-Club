# == Schema Information
#
# Table name: loan_documents
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
#  loan_id                 :uuid
#  owner_type              :string
#

class OtherLoanReport < LoanDocument
  belongs_to :loan, inverse_of: :other_loan_report, foreign_key: 'loan_id'
  belongs_to :owner, polymorphic: true
end
