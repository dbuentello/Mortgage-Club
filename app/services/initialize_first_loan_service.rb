class InitializeFirstLoanService
  attr_reader :user, :info, :properties

  def initialize(user, quote_cookies = nil)
    @user = user
    @info = parse_cookies(quote_cookies)
    @properties = []
  end

  def call
    init_properties

    Loan.create(
      purpose: info["mortgage_purpose"],
      user: user,
      properties: properties,
      closing: Closing.create(name: "Closing"),
      status: "new_loan"
    )
  end

  private

  def parse_cookies(quote_cookies)
    return {} if quote_cookies.nil?

    begin
      info = JSON.parse(quote_cookies)
    rescue JSON::ParserError
      info = {}
    end

    info
  end

  def create_subject_property
    Property.create(
      is_subject: true,
      purchase_price: get_purchase_price,
      original_purchase_price: get_original_purchase_price,
      property_type: info["property_type"],
      usage: info["property_usage"],
      address: Address.create
    )
  end

  def init_properties
    properties << create_subject_property
    properties << create_primary_property if current_address_is_owner?
  end

  def create_primary_property
    address = borrower_current_address.address

    Property.create(
      is_primary: true,
      address: Address.create(
        street_address: address.street_address,
        zip: address.zip,
        state: address.state,
        city: address.city,
        full_text: address.full_text
      )
    )
  end

  def current_address_is_owner?
    borrower_current_address && borrower_current_address.is_rental == false
  end

  def purchase_loan?
    info["mortgage_purpose"] == "purchase"
  end

  def refinance_loan?
    info["mortgage_purpose"] == "refinance"
  end

  def get_purchase_price
    info["property_value"] if purchase_loan?
  end

  def get_original_purchase_price
    info["property_value"] if refinance_loan?
  end

  def borrower_current_address
    return nil if user.borrower.nil? || user.borrower.current_address.nil?

    user.borrower.current_address
  end
end
