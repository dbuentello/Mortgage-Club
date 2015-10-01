class CreateBorrowerForm
  include ActiveModel::Model

  ATTRIBUTES = [
    :email, :first_name, :last_name, :middle_name, :last_name,
    :suffix, :dob, :ssn, :phone, :years_in_school, :marital_status,
    :dependent_count, :dependent_ages, :current_address, :currently_own,
    :years_in_current_address, :previous_address, :previously_own,
    :years_in_previous_address
  ]

  attr_accessor *ATTRIBUTES

  def initialize(attributes)
    ATTRIBUTES.each do |attribute|
      send("#{attribute}=", attributes[attribute])
    end
  end

  validate do
  end

  def save
    address.save!
    borrower_address.save!
    borrower.save!
  rescue ActiveRecord => error
    @object.errors.full_messages
  end

  private

  def address
  end

  def borrower_address
  end

  def borrower
  end
end