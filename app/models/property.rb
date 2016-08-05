class Property < ActiveRecord::Base
  belongs_to :loan, foreign_key: "loan_id"

  has_one :address, autosave: true, inverse_of: :property
  has_many :liabilities, dependent: :destroy, foreign_key: "property_id"
  has_many :documents, as: :subjectable, dependent: :destroy

  accepts_nested_attributes_for :address

  PERMITTED_ATTRS = [
    :property_type,
    :usage,
    :original_purchase_year,
    :original_purchase_price,
    :purchase_price,
    :gross_rental_income,
    :market_price,
    :estimated_property_tax,
    :estimated_hazard_insurance,
    :estimated_mortgage_insurance,
    :estimated_mortgage_balance,
    :mortgage_includes_escrows,
    :estimated_principal_interest,
    :is_impound_account,
    :hoa_due,
    :is_primary,
    :is_subject,
    :year_built,
    :zillow_image_url,
    address_attributes: [:id] + Address::PERMITTED_ATTRS
  ]

  enum property_type: {
    sfh: 0,
    duplex: 1,
    triplex: 2,
    fourplex: 3,
    condo: 4
  }

  enum usage: {
    primary_residence: 0,
    vacation_home: 1,
    rental_property: 2
  }

  enum mortgage_includes_escrows: {
    taxes_and_insurance: 0,
    taxes_only: 1,
    no: 2,
    not_sure: 3
  }

  validates_associated :address

  def mortgage_payment_liability
    @mortgage_payment_liability ||= liabilities.where(account_type: "Mortgage").last
  end

  def other_financing_liability
    liabilities.where.not(account_type: "Mortgage").last
  end

  def usage_name
    return unless usage
    usage.split("_").map(&:capitalize).join(" ")
  end

  def completed?
    property_type.present? && usage.present? &&
      address.present? && address.completed &&
      market_price.present? && mortgage_includes_escrows.present? &&
      estimated_property_tax.present? && estimated_hazard_insurance.present?
  end

  def rental_propery_completed?
    property_type.present? && address.present? &&
      address.completed && market_price.present? &&
      mortgage_includes_escrows.present? && estimated_property_tax.present? &&
      estimated_hazard_insurance.present?
  end

  def refinance_completed?
    original_purchase_price.present? && original_purchase_year.present?
  end

  def actual_rental_income
    gross_rental_income.to_f * 0.75
  end

  def liability_payments
    liabilities.sum(:payment)
  end

  def mortgage_payment
    mortgage_payment_liability.present? ? mortgage_payment_liability.payment.to_f : 0
  end

  def other_financing
    liability = liabilities.where(account_type: "OtherFinancing").last
    liability.present? ? liability.payment.to_f : 0
  end

  # def update_mortgage_payment_amount
  #   return unless mortgage_payment_liability && mortgage_includes_escrows

  #   mortgage_payment = mortgage_payment_liability.payment.to_f
  #   case mortgage_includes_escrows
  #   when "taxes_and_insurance"
  #     fee = estimated_property_tax.to_f - estimated_hazard_insurance.to_f
  #   when "taxes_only"
  #     fee = estimated_property_tax.to_f
  #   when "no"
  #     fee = estimated_hazard_insurance.to_f
  #   end
  #   self.update(mortgage_payment: mortgage_payment - fee)
  # end

  def no_of_unit
    case property_type
    when "sfh", "condo"
      return 1
    when "duplex"
      return 2
    when "triplex"
      return 3
    when "fourplex"
      return 4
    end
  end

  def refinance_amount
    return 0 unless loan.refinance?
    return 0 unless mortgage_payment_liability || other_financing_liability

    if mortgage_payment_liability
      amount = mortgage_payment_liability.balance.to_f
    else
      amount = other_financing_liability.balance.to_f
    end
    amount
  end

  def total_liability_balance
    mortgage_balance = mortgage_payment_liability ? mortgage_payment_liability.balance.to_f : 0
    other_balance = other_financing_liability ? other_financing_liability.balance.to_f : 0
    mortgage_balance + other_balance
  end

  def other_documents
    documents.where(document_type: "other_property_report")
  end

  def self.json_options
    {
      include: [
        :liabilities, :address
      ]
    }
  end
end
