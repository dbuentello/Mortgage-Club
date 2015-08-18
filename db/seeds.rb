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

  loan = user.loans.build(amount: Random.rand(100000..200000), interest_rate: Random.rand(5..15))
  loan.save

  hud_estimate = loan.create_hud_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
  hud_final = loan.create_hud_final(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
  loan_estimate = loan.create_loan_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
  loan_estimate = loan.create_uniform_residential_lending_application(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)

  property = loan.build_property(purchase_price: Random.rand(100000..200000))
  property.create_address(street_address: "208 Silver Eagle Road")
  property.save

  appraisal_report = property.create_appraisal_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
  mortgage_statement = property.create_mortgage_statement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
  purchase_agreement = property.create_purchase_agreement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)
  risk_report = property.create_risk_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'), owner: user)

end

# create staff user
if User.where(email: 'loan_member@gmail.com').blank?
  user = User.new(
    email: 'loan_member@gmail.com', first_name: 'Mark', last_name: 'Lim',
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

# if Template.where(name: 'Loan Estimation').blank?
#   base = Docusign::Base.new
#   template = base.create_template_object_from_name("Loan Estimation")
# end
