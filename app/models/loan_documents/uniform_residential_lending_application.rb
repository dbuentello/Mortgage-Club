class UniformResidentialLendingApplication < LoanDocument

  belongs_to :loan, inverse_of: :hud_estimate, foreign_key: 'owner_id'
end
