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
    loan = Loan.find_by_id(@loan_id)
    if @rental_properties.present?
      i = 0
      @rental_properties.each do |property|
        property_attributes = property_params(property[1])
        rental_property = nil
        if i < loan.rental_properties.size
          rental_property = loan.rental_properties[i]
          rental_property.update(property_attributes)
        else
          new_property = Property.new(property_attributes)
          new_property.loan_id = @loan_id
          new_property.save
          rental_property = new_property
        end

        save_mortgage_payment(rental_property, property[1])
        save_other_financing(rental_property, property[1])

        i += 1
      end
    end
    loan.primary_property.update(property_params(@primary_property))
    save_mortgage_payment(loan.primary_property, @primary_property)
    save_other_financing(loan.primary_property, @primary_property)
  end

  private
  def property_params(params)
    params.permit(Property::PERMITTED_ATTRS)
  end

  def save_mortgage_payment(property, property_params)
    byebug
    property.liabilities.each do |liability|
      liability.property_id = nil
      liability.save
    end

    if property_params['mortgage_payment'] == 'Other'
      liability = Liability.new
      liability.liability_type = "Other Mortgage"
      liability.payment = property_params['other_mortgage_payment']
      liability.property_id = property.id
      liability.user_input = true
      liability.save
    else
      liability = Liability.find_by_id(property_params['mortgage_payment'])
      liability.liability_type = "Mortgage"
      liability.property_id = property.id
      liability.save
    end
  end

  def save_other_financing(property, property_params)
    if property_params['financing'] == 'Other'
      liability = Liability.new
      liability.liability_type = "Other Financing"
      liability.payment = property_params['other_financing']
      liability.property_id = property.id
      liability.user_input = true
      liability.save
    else
      liability = Liability.find_by_id(property_params['financing'])
      liability.liability_type = "Financing"
      liability.property_id = property.id
      liability.save
    end
  end

end