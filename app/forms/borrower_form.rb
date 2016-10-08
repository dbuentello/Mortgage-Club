class BorrowerForm
  include ActiveModel::Model

  attr_accessor :borrower, :loan, :form_params, :is_primary_borrower

  validate :validate_attributes

  def save
    assign_value_to_attributes
    setup_associations
    return false unless valid?

    ActiveRecord::Base.transaction do
      borrower.save!
      current_address.save!
      current_borrower_address.save!
      update_primary_property if primary_borrower?
      update_required_documents

      if borrower.must_have_previous_address?
        update_old_address
      else
        borrower.previous_address.destroy if borrower.previous_address
      end
    end
    true
  end

  def update_primary_property
    if borrower_rents_house?
      unset_primary_property
    else
      create_primary_property
    end
  end

  def borrower_rents_house?
    current_borrower_address.is_rental
  end

  def unset_primary_property
    loan.primary_property.destroy if loan.primary_property
  end

  def create_primary_property
    return if loan.primary_property.present?

    property = Property.create(
      loan: loan,
      is_primary: true,
      usage: "primary_residence"
    )

    Address.create(
      street_address: current_address.street_address,
      street_address2: current_address.street_address2,
      zip: current_address.zip,
      state: current_address.state,
      city: current_address.city,
      full_text: current_address.full_text,
      property_id: property.id
    )

    property
  end

  def update_required_documents
    if loan.borrower.id == borrower.id
      update_borrower_required_documents
    elsif loan.secondary_borrower
      update_co_borrower_required_documents
    end
  end

  def update_borrower_required_documents
    if loan.borrower.is_editted_by_loan_member.nil?
      borrower_required_documents = []

      if borrower.self_employed
        borrower_required_documents = ["first_personal_tax_return", "second_personal_tax_return", "first_business_tax_return", "second_business_tax_return", "first_bank_statement", "second_bank_statement"]
      else
        borrower_required_documents = ["first_w2", "second_w2", "first_paystub", "second_paystub", "first_personal_tax_return", "second_personal_tax_return", "first_bank_statement", "second_bank_statement"]
      end

      borrower.documents.update_all(is_required: false)
      borrower.documents.where(document_type: borrower_required_documents).update_all(is_required: true)
    end
  end

  def update_co_borrower_required_documents
    co_borrower_required_documents = []
    secondary_borrower = loan.secondary_borrower
    if secondary_borrower.self_employed
      if loan.borrower.is_file_taxes_jointly
        co_borrower_required_documents = ["first_business_tax_return", "second_business_tax_return"]
      else
        co_borrower_required_documents = ["first_personal_tax_return", "second_personal_tax_return", "first_business_tax_return", "second_business_tax_return"]
      end
    else
      if loan.borrower.is_file_taxes_jointly
        co_borrower_required_documents = ["first_w2", "second_w2", "first_paystub", "second_paystub"]
      else
        co_borrower_required_documents = ["first_w2", "second_w2", "first_paystub", "second_paystub", "first_personal_tax_return", "second_personal_tax_return"]
      end
    end

    secondary_borrower.documents.update_all(is_required: false)
    co_borrower_required_documents.each do |document_type|
      document = Document.find_or_initialize_by(subjectable_id: secondary_borrower.id, document_type: document_type)

      document.subjectable_type = "Borrower"
      document.description = Document::BORROWER_DOCUMENT_DESCRIPTION[document_type]
      document.user_id = borrower.user_id
      document.is_required = true

      document.save
    end
  end

  private

  def assign_value_to_attributes
    current_address.assign_attributes(form_params[:current_address])
    current_borrower_address.assign_attributes(form_params[:current_borrower_address])
    borrower.assign_attributes(form_params[:borrower])
  end

  def setup_associations
    current_borrower_address.address = current_address
    borrower.borrower_addresses << current_borrower_address
  end

  def update_old_address
    previous_address.save! if previous_address
    previous_borrower_address.save!
  end

  def primary_borrower?
    is_primary_borrower
  end

  def validate_attributes
    add_errors(address.errors) if current_address.invalid?
    add_errors(current_borrower_address.errors) if current_borrower_address.invalid?
    add_errors(borrower.errors) if borrower.invalid?
  end

  def add_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def current_borrower_address
    @current_borrower_address ||= borrower.current_address || BorrowerAddress.new
  end

  def current_address
    @current_address ||= begin
      borrower.current_address.present? ? borrower.current_address.address : Address.new
    end
  end

  def previous_address
    @previous_address ||= begin
      if form_params[:previous_address][:id]
        # existing record
        address = Address.find(form_params[:previous_address][:id])
        address.assign_attributes(form_params[:previous_address])
      else
        address = Address.new(form_params[:previous_address])
      end
      address if address.valid?
    end
  end

  def previous_borrower_address
    @previous_borrower_address ||= begin
      borrower_address = BorrowerAddress.find_or_initialize_by(borrower: borrower, is_current: false)
      borrower_address.assign_attributes(form_params[:previous_borrower_address])
      borrower_address.address = previous_address
      borrower_address
    end
  end
end
