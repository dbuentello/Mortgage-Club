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
      down_payment: info["down_payment"],
      amount: info["loan_amount"],
      interest_rate: info["interest_rate"],
      lender_name: info["lender_name"],
      amortization_type: info["amortization_type"],
      num_of_months: info["period"],
      apr: info["apr"],
      lender_nmls_id: info["lender_nmls_id"],
      lender_credits: info["lender_credits"],
      monthly_payment: info["monthly_payment"],
      loan_type: get_loan_type,
      estimated_closing_costs: info["total_closing_cost"],
      pmi_monthly_premium_amount: info["pmi_monthly_premium_amount"],
      user: user,
      properties: properties,
      closing: Closing.create(name: "Closing"),
      status: "new_loan",
      own_investment_property: borrower_has_other_properties? ? true : false,
      lender_underwriting_fee: info["lender_nmls_id"],
      appraisal_fee: info["appraisal_fee"],
      tax_certification_fee: info["tax_certification_fee"],
      flood_certification_fee: info["flood_certification_fee"],
      outside_signing_service_fee: info["outside_signing_service_fee"],
      concurrent_loan_charge_fee: info["concurrent_loan_charge_fee"],
      endorsement_charge_fee: info["endorsement_charge_fee"],
      lender_title_policy_fee: info["lender_title_policy_fee"],
      recording_service_fee: info["recording_service_fee"],
      settlement_agent_fee: info["settlement_agent_fee"],
      recording_fees: info["recording_fees"],
      owner_title_policy_fee: info["owner_title_policy_fee"],
      prepaid_item_fee: info["prepaid_item_fee"],
      discount_pts: info["discount_pts"]
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
    property = Property.create(
      is_subject: true,
      purchase_price: get_purchase_price,
      original_purchase_price: get_original_purchase_price,
      estimated_mortgage_balance: get_estimated_mortgage_balance,
      property_type: info["property_type"],
      usage: info["property_usage"]
    )
    Address.create(property_id: property.id)

    property
  end

  def init_properties
    @properties << create_subject_property
    @properties << create_primary_property if borrower_own_current_address?
    @properties += create_other_properties if borrower_has_other_properties?
  end

  def create_primary_property
    property = Property.create(
      is_primary: true,
      usage: "primary_residence"
    )
    address = borrower_current_address.address

    Address.create(
      street_address: address.street_address,
      street_address2: address.street_address2,
      zip: address.zip,
      state: address.state,
      city: address.city,
      full_text: address.full_text,
      property_id: property.id
    )

    property
  end

  def create_other_properties
    other_properties = []
    other_properties_json = JSON.load(@borrower.other_properties)

    other_properties_json.each do |other_property_json|
      property = Property.create(
        property_type: other_property_json["property_type"],
        usage: "rental_property",
        original_purchase_year: other_property_json["original_purchase_year"].nil? ? nil : other_property_json["original_purchase_year"].to_i,
        original_purchase_price: other_property_json["original_purchase_price"].nil? ? nil : other_property_json["original_purchase_price"].to_f,
        purchase_price: other_property_json["purchase_price"].nil? ? nil : other_property_json["purchase_price"].to_f,
        market_price: other_property_json["market_price"].nil? ? nil : other_property_json["market_price"].to_f,
        gross_rental_income: other_property_json["gross_rental_income"].nil? ? nil : other_property_json["gross_rental_income"].to_f,
        estimated_property_tax: other_property_json["estimated_property_tax"].nil? ? nil : other_property_json["estimated_property_tax"].to_f,
        estimated_hazard_insurance: other_property_json["estimated_hazard_insurance"].nil? ? nil : other_property_json["estimated_hazard_insurance"].to_f,
        is_impound_account: nil,
        estimated_mortgage_insurance: other_property_json["estimated_mortgage_insurance"].nil? ? nil : other_property_json["estimated_mortgage_insurance"].to_f,
        mortgage_includes_escrows: other_property_json["mortgage_includes_escrows"],
        hoa_due: other_property_json["hoa_due"].nil? ? nil : other_property_json["hoa_due"].to_f,
        is_primary: false,
        is_subject: false,
        year_built: other_property_json["year_built"].nil? ? nil : other_property_json["year_built"].to_i,
        zillow_image_url: "",
        estimated_mortgage_balance: other_property_json["estimated_mortgage_balance"].nil? ? nil : other_property_json["estimated_mortgage_balance"].to_f,
        estimated_principal_interest: other_property_json["estimated_principal_interest"].nil? ? nil : other_property_json["estimated_principal_interest"].to_f
      )

      address_json = other_property_json["address"]
      Address.create(
        street_address: address_json["street_address"],
        street_address2: address_json["street_address2"],
        zip: address_json["zip"],
        state: address_json["state"],
        city: address_json["city"],
        full_text: address_json["full_text"],
        property_id: property.id
      )

      other_properties << property
    end

    other_properties
  end

  def borrower_own_current_address?
    return false if borrower.nil?
    return false if borrower.current_address.nil?
    return false if borrower.current_address.address.nil?

    borrower_current_address.is_rental == false
  end

  def get_loan_type
    loan_type = nil
    byebug
    if info["loan_type"].present?
      if info["loan_type"] == "CONVENTIONAL"
        loan_type = info["loan_type"].capitalize
      else
        loan_type = info["loan_type"].uppercase
      end
    end

    loan_type
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

  def get_estimated_mortgage_balance
    info["mortgage_balance"] if refinance_loan?
  end

  def borrower_current_address
    borrower.current_address
  end

  def assign_loan_to_billy(loan)
    return unless user = User.where(email: "billy@mortgageclub.co").last
    manager = LoanMembersTitle.find_or_create_by(title: "Mortgage Advisor")
    user.loan_member.loans_members_associations.find_or_create_by(loan_id: loan.id, loan_members_title: manager)
    # create the first loan activity
    activity = ActivityType.find_or_create_by(label: "Start processing") do |r|
      r.type_name_mapping = "{Start processing the loan by MortgageClub}"
    end
    # add the first activity to loan
    LoanActivityServices::CreateActivity.new.call(user.loan_member, loan_activity_params(activity, loan))
  end

  def loan_activity_params(activity, loan)
    loan_activity_params = {}
    loan_activity_params[:activity_type_id] = activity.id
    loan_activity_params[:activity_status] = 0
    loan_activity_params[:name] = activity.type_name_mapping[0]
    loan_activity_params[:user_visible] = true
    loan_activity_params[:loan_id] = loan.id
    loan_activity_params[:start_date] = Time.zone.now
    loan_activity_params
  end

  def borrower_has_other_properties?
    @borrower.other_properties.present?
  end
end
