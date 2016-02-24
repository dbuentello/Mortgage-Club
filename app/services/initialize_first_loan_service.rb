class InitializeFirstLoanService
  attr_reader :user, :info, :properties, :borrower

  def initialize(user, quote_cookies = nil)
    @user = user
    @info = parse_cookies(quote_cookies)
    @properties = []
    @borrower = user.borrower
  end

  def call
    init_properties

    loan = Loan.create(
      purpose: info["mortgage_purpose"],
      user: user,
      properties: properties,
      closing: Closing.create(name: "Closing"),
      status: "new_loan"
    )

    assign_loan_to_billy(loan)

    loan
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
    properties << create_primary_property if borrower_own_current_address?
  end

  def create_primary_property
    address = borrower_current_address.address

    Property.create(
      is_primary: true,
      usage: "primary_residence",
      address: Address.create(
        street_address: address.street_address,
        street_address2: address.street_address2,
        zip: address.zip,
        state: address.state,
        city: address.city,
        full_text: address.full_text
      )
    )
  end

  def borrower_own_current_address?
    return false if borrower.nil?
    return false if borrower.current_address.nil?
    return false if borrower.current_address.address.nil?

    borrower_current_address.is_rental == false
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
    borrower.current_address
  end

  def assign_loan_to_billy(loan)
    return unless user = User.where(email: "billy@mortgageclub.co").last
    manager = LoanMembersTitle.find_or_create_by(title: "manager")
    user.loan_member.loans_members_associations.find_or_create_by(loan_id: loan.id, loan_members_title: manager)
  end
end
