class CreateBorrowerForm
  include ActiveModel::Model

  ATTRIBUTES = [
    :email, :first_name, :last_name, :middle_name, :last_name,
    :suffix, :dob, :ssn, :phone, :years_in_school, :marital_status,
    :dependent_count, :dependent_ages, :address_attr, :currently_own,
    :years_in_current_address, :previous_address, :previously_own,
    :years_in_previous_address, :borrower_address_attr
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
    return false unless valid?

    borrower_address.save!
    address.save!
    borrower.save!
  rescue ActiveRecord => error
    @object.errors.full_messages
  end

  private

  def borrower_address
    @borrower_address ||= BorrowerAddress.new(borrower_address_attr)
  end

  def address
    # current_address" => {
    #                           "id" => "c2ae0b9f-3a79-4091-8870-368c09c2626b",
    #                  "borrower_id" => "a80f00b4-f2ff-4b95-8c15-a9bf3f690275",
    #             "years_at_address" => "",
    #                    "is_rental" => "true",
    #                   "is_current" => "true",
    #                   "created_at" => "2015-10-01T03:07:29.596Z",
    #                   "updated_at" => "2015-10-01T03:07:29.596Z",
    #               "cached_address" => ""
    #         },
    current_address
  end

  def borrower
  end
end