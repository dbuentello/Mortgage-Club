# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create user with its borrower
if User.where(email: 'borrower@gmail.com').blank?
  user = User.new(email: 'borrower@gmail.com', password: '12345678', password_confirmation: '12345678')
  user.skip_confirmation!
  user.save

  user.create_borrower
  user.add_role :borrower

  loan = user.build_loan
  loan.save

  hud_estimate = loan.create_hud_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  hud_final = loan.create_hud_final(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  loan_estimate = loan.create_loan_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  loan_estimate = loan.create_uniform_residential_lending_application(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))

  property = loan.build_property
  property.create_address
  property.save

  appraisal_report = property.create_appraisal_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  mortgage_statement = property.create_mortgage_statement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  purchase_agreement = property.create_purchase_agreement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  risk_report = property.create_risk_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))

end

# create staff user
if User.where(email: 'loan_member@gmail.com').blank?
  user = User.new(email: 'loan_member@gmail.com', password: '12345678', password_confirmation: '12345678')
  user.skip_confirmation!
  user.save

  user.create_loan_member
  user.add_role :loan_member
end

# if Template.where(name: 'Loan Estimation').blank?
#   base = Docusign::Base.new
#   template = base.create_template_object_from_name("Loan Estimation")
# end
