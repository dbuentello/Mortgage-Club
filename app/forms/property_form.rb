class PropertyForm
  include ActiveModel::Model

  attr_accessor :loan, :primary_property, :rental_properties, :primary_property_params, :rental_properties_params

  validate :validate_attributes

  def assign_value_to_attributes
    primary_property.assign_attributes(property_params(primary_property_params))
    primary_property.address.assign_attributes(address_params(primary_property_params))
    assign_attributes_for_existing_properties
    assign_attributes_for_new_properties
  end

  def save
    assign_value_to_attributes
    return false unless valid?

    Property.transaction do
      primary_property.save!

      rental_properties.each do |rental_property|
        rental_property.save!
      end
    end
  end

  def primary_property
    @primary_property ||= Property.new
  end

  def rental_properties
    @rental_properties ||= [Property.new]
  end

  def assign_attributes_for_existing_properties
    rental_properties.each do |property|
      params = rental_properties_params[property.id]

      if params[:remove] == "true"
        remove_property(property)
      else
        property.assign_attributes(property_params(params))
        property.address.assign_attributes(address_params(params))
      end

      # we will call assign_attributes_for_new_properties method later
      # so we have to remove params of existing properties
      rental_properties_params.delete(params)
    end
  end

  def remove_property(property)
    rental_properties.delete(property)
    property.destroy
  end

  def assign_attributes_for_new_properties
    rental_properties_params.each do |params|
      property = Property.new
      property.assign_attributes(property_params(params))
      property.build_address(address_params(params))
      property.loan_id = loan.id
      rental_properties_params << property
    end
  end

  # validates :loan_id, :properties, presence: true

  # def save
  #   loan = Loan.find_by_id(@loan_id)
  #   if @rental_properties.present?
  #     i = 0
  #     @rental_properties.each do |property|
  #       property_attributes = property_params(property[1])
  #       if i < loan.rental_properties.size
  #         loan.rental_properties[i].update(property_attributes)
  #       else
  #         new_property = Property.new(property_attributes)
  #         new_property.loan_id = @loan_id
  #         new_property.save
  #       end
  #       i += 1
  #     end
  #   end
  #   loan.primary_property.update(property_params(@primary_property))
  # end

  private

  def validate_attributes
    add_errors(primary_property.errors) if primary_property.invalid?

    rental_properties.each do |property|
      add_errors(property.errors) if property.invalid?
    end
  end

  def add_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def property_params(params)
    ActionController::Parameters.new(params).require(:property).permit(Property::PERMITTED_ATTRS)
  end

  def address_params(params)
    ActionController::Parameters.new(params).require(:address).permit(Address::PERMITTED_ATTRS)
  end
end