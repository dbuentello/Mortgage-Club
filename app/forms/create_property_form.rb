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

    # if @rental_properties.present?
    #   @rental_properties.each do |property|
    #     new_property = Property.new(property_params(property[1]))
    #     new_property.loan_id = @loan_id
    #     new_property.save
    #   end
    # end
    true
  end

  private

  def property_params(params)
    params.permit(Property::PERMITTED_ATTRS);
  end

end