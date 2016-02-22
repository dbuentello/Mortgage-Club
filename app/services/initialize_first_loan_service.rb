class InitializeFirstLoanService
  attr_reader :user, :info

  def initialize(user, quote_cookies = nil)
    @user = user
    @info = parse_cookies(quote_cookies)
  end

  def call
    properties = [create_property]

    current_address = user.borrower.current_address

    if(current_address && current_address.is_rental == false)
      properties << create_primary_property
    end

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

  def create_property
    Property.create(
      is_subject: true,
      purchase_price: get_purchase_price,
      original_purchase_price: get_original_purchase_price,
      property_type: info["property_type"],
      usage: info["property_usage"],
      address: Address.create
    )
  end

  def create_primary_property
    address = user.borrower.current_address.address

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
end
