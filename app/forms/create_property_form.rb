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
    # loan_primary_property.update(property_type: @primary_property[:property_type], market_price: @primary_property[:market_price], estimated_property_tax: @primary_property[:estimated_property_tax], hoa_due: @primary_property[:hoa_due])

    # @rental_properties.each do |property|
    #   Property.create(property)
    # end
    true
  end

  private

  def update_attr
      params.require(:primary_property).permit(:property_type, :market_price, :estimated_property_tax, :hoa_due);
  end

end