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
  has_one :closing_disclosure, inverse_of: :closing, dependent: :destroy, foreign_key: 'closing_id'
  has_one :deed_of_trust, inverse_of: :closing, dependent: :destroy, foreign_key: 'closing_id'
  has_one :loan_doc, inverse_of: :closing, dependent: :destroy, foreign_key: 'closing_id'
  has_many :other_closing_reports, dependent: :destroy, foreign_key: 'closing_id'
  has_many :closing_documents, dependent: :destroy, foreign_key: 'closing_id'
end
