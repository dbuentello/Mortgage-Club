# == Schema Information
#
# Table name: closings
#
#  id      :uuid             not null, primary key
#  name    :string
#  loan_id :uuid
#

class Closing < ActiveRecord::Base
  belongs_to :loan, inverse_of: :closing, foreign_key: 'loan_id'

  has_many :documents, as: :subjectable, dependent: :destroy

  def other_documents
    documents.where(document_type: "other_closing_report")
  end
end
