# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create user with its borrower
if User.where(email: 'borrower@gmail.com').blank?
  user = User.new(
    email: 'borrower@gmail.com', first_name: 'John', last_name: 'Doe',
    password: '12345678', password_confirmation: '12345678'
  )
  user.skip_confirmation!
  user.save

  user.create_borrower
  user.add_role :borrower

  loan = user.loans.build(amount: Random.rand(100000..200000), interest_rate: Random.rand(0.2..1))
  loan.save

  property = Property.new(purchase_price: Random.rand(100000..200000), is_primary: true, loan_id: loan.id)
  property.create_address(street_address: "208 Silver Eagle Road")
  property.save
end

# create staff user
if User.where(email: 'loan_member@mortgageclub.co').blank?
  user = User.new(
    email: 'loan_member@mortgageclub.co', first_name: 'Mark', last_name: 'Lim',
    password: '12345678', password_confirmation: '12345678'
  )
  user.skip_confirmation!
  user.save

  user.create_loan_member
  user.add_role :loan_member
end


if User.where(email: 'billy@mortgageclub.io').blank?
  user = User.new(
    email: 'billy@mortgageclub.io', first_name: 'Billy', last_name: 'Tran',
    password: '12345678', password_confirmation: '12345678'
  )
  user.skip_confirmation!
  user.save

  user.create_loan_member
  user.add_role :loan_member
end

if User.where(email: 'admin@mortgageclub.io').blank?
  user = User.new(
    email: 'admin@mortgageclub.io', first_name: 'Admin', last_name: 'Day',
    password: '12345678', password_confirmation: '12345678'
  )
  user.skip_confirmation!
  user.save

  user.add_role :admin
end

if User.where(email: 'coborrower@gmail.com').blank?
  user = User.new(
    email: 'coborrower@gmail.com', first_name: 'Tom', last_name: 'Cruise',
    password: '12345678', password_confirmation: '12345678'
  )
  user.skip_confirmation!
  user.save
  user.create_borrower
  user.add_role :borrower
end

if User.where(email: 'purchase_1borrower@gmail.com').blank?
  new_user_emails = [
    "purchase_1borrower@gmail.com",
    "refinance_1borrower@gmail.com",
    "purchase_2borrowers@gmail.com",
    "refinance_2borrowers@gmail.com"
  ]

  i = 1
  new_user_emails.each do |e|
    user = User.new(
      email: e, first_name: 'Borrower', last_name: i.to_s,
      password: '12345678', password_confirmation: '12345678'
    )
    user.skip_confirmation!
    user.save
    user.create_borrower
    user.add_role :borrower
    i += 1
  end
end

if Template.where(name: "Loan Estimate").blank?
  Docusign::CreateTemplateService.call("Loan Estimate", {document_order: 1})
end

if Template.where(name: "Servicing Disclosure").blank?
  Docusign::CreateTemplateService.call("Servicing Disclosure", {document_order: 2})
end

if Template.where(name: "Generic Explanation").blank?
  Docusign::CreateTemplateService.call("Generic Explanation", {document_order: 3})
end

if Lender.where(name: 'Dummy Lender').blank?
  lender = Lender.create_dummy_lender

  template = LenderTemplate.new(name: "Wholesale Submission Form", description: "This is a wholesale submission form")
  requirement = template.lender_template_requirements.build(lender: lender)
  requirement.save!

  Loan.all.each do |loan|
    next if loan.lender
    loan.lender = lender
    loan.save!
  end
end

if Template.where(name: 'Uniform Residential Loan Application').blank?
  Docusign::CreateTemplateService.call("Uniform Residential Loan Application")
end

# if Loan.where(lender_name: 'Ficus Bank').blank?
#   user = User.where(email: 'borrower@gmail.com').first
#   loan = user.loans.build(amount: Random.rand(100000..200000), interest_rate: Random.rand(0.2..1))
#   loan.save

#   #build cobororwer
#   second_user = User.where(email: 'coborrower@gmail.com').last
#   loan.secondary_borrower = second_user.borrower

#   hud_estimate = loan.create_hud_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   hud_final = loan.create_hud_final(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   loan_estimate = loan.create_loan_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   loan_estimate = loan.create_uniform_residential_lending_application(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   property = Property.new(purchase_price: Random.rand(100000..200000), is_primary: true, loan_id: loan.id)
#   property.create_address(street_address: "208 Silver Eagle Road")
#   property.save
#   appraisal_report = property.create_appraisal_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   mortgage_statement = property.create_mortgage_statement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   purchase_agreement = property.create_purchase_agreement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   risk_report = property.create_risk_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
#   ['estimated_hazard_insurance', 'estimated_property_tax'].each do |attribute|
#     property.send("#{attribute}=", Random.rand(1000..5000))
#   end
#   property.save

#   #loan
#   loan.amortization_type = ['15 year fixed', '30 year fixed'].sample
#   loan.loan_type = ['Conventional', 'VA', 'FHA'].sample
#   loan.num_of_months = Random.rand(12..36)

#   [
#     'monthly_payment', 'prepayment_penalty_amount', 'payment_calculation', 'pmi', 'estimated_closing_costs',
#     'loan_costs', 'other_costs', 'lender_credits', 'estimated_cash_to_close', 'application_fee',
#     'underwriting_fee', 'points', 'appraisal_fee', 'credit_report_fee', 'flood_determination_fee',
#     'flood_monitoring_fee', 'tax_monitoring_fee', 'tax_status_research_fee', 'pest_inspection_fee',
#     'survey_fee', 'insurance_binder', 'lenders_title_policy', 'settlement_agent_fee', 'title_search',
#     'recording_fees_and_other_taxes', 'transfer_taxes', 'homeowners_insurance_premium', 'mortgage_insurance_premium',
#     'prepaid_interest_per_day', 'prepaid_property_taxes', 'pmi_monthly_premium_amount',
#     'owner_title_policy', 'lender_credits', 'closing_costs_financed', 'down_payment', 'deposit',
#     'funds_for_borrower', 'seller_credits', 'adjustments_and_other_credits','in_5_years_total', 'in_5_years_principal'
#   ].each do |attribute|
#     loan.send("#{attribute}=", Random.rand(1000..5000))
#   end

#   [
#     'homeowners_insurance_premium_months', 'mortgage_insurance_premium_months', 'prepaid_interest_days',
#     'prepaid_property_taxes_months', 'initial_homeowner_insurance_months', 'initial_mortgage_insurance_months', 'initial_property_taxes_months'
#   ].each do |attribute|
#     loan.send("#{attribute}=", Random.rand(1..20))
#   end

#   [
#     'loan_amount_increase', 'interest_rate_increase', 'monthly_principal_interest_increase',
#     'prepayment_penalty', 'balloon_payment', 'include_property_taxes', 'include_homeowners_insurance',
#     'include_other', 'in_escrow_property_taxes', 'in_escrow_homeowners_insurance', 'rate_lock',
#     'in_escrow_other', 'assumption_will_allow', 'assumption_will_not_allow', 'servicing_service', 'servicing_transfer'
#   ].each do |attribute|
#     loan.send("#{attribute}=", [true, false].sample)
#   end

#   loan.lender_name = 'Ficus Bank'
#   loan.loan_officer_name_1 = 'Joe Smith'
#   loan.loan_officer_email_1 = 'joesmith@ficusbank.com'
#   loan.loan_officer_phone_1 = '123-456-7890'
#   loan.lender_nmls_id = '#123456789'
#   loan.loan_officer_nmls_id_1 = '#987654321'
#   loan.annual_percentage_rate = 0.42
#   loan.total_interest_percentage = 0.6945
#   loan.late_days = 15
#   loan.save
# end