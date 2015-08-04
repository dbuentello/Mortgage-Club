class HomeownersInsurance < PropertyDocument

  belongs_to :property, inverse_of: :appraisal_report, foreign_key: 'owner_id'
end
