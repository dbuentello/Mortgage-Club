class CreatePropertyForm
  include ActiveModel::Model

  attr_accessor :loan_id, :properties

  def initialize(loan_id, primary_property, rental_properties)
    @loan_id = loan_id
    @primary_property = primary_property
    @rental_properties = rental_properties
  end

  validates :loan_id, :properties, presence: true

  def save
    loan_primary_property = Loan.find_by_id(@loan_id).primary_property
    loan_primary_property.update(property_params(@primary_property))

    @rental_properties.each do |property|
    #   Property.create(property)
    end
    true
  end

  private

  def property_params(params)
      params.permit(
        :property_type,
        :market_price,
        :estimated_mortgage_insurance,
        :mortgage_includes_escrows,
        :estimated_property_tax,
        :estimated_hazard_insurance,
        :hoa_due,
        :gross_rental_income,
      );
  end

end