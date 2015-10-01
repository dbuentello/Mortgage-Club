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
        if i < loan.rental_properties.size
          loan.rental_properties[i].update(property_attributes)
        else
          new_property = Property.new(property_attributes)
          new_property.loan_id = @loan_id
          new_property.save
        end
        i += 1
      end
    end
    loan.primary_property.update(property_params(@primary_property))
  end

  private

  def property_params(params)
    params.permit(Property::PERMITTED_ATTRS)
  end

end