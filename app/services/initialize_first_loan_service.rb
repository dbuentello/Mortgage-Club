class InitializeFirstLoanService
  attr_reader :user, :info

  def initialize(user, quote_cookies)
    @user = user
    @info = parse_cookies(quote_cookies)
  end

  def call
    Loan.create(
      purpose: info["mortgage_purpose"],
      user: user,
      properties: [create_property],
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
