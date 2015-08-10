# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create user with its borrower
if User.where(email: 'lehoang1417@gmail.com').blank?
  user = FactoryGirl.build(:user, email: 'lehoang1417@gmail.com', password: '12345678',
    password_confirmation: '12345678')
  user.skip_confirmation!
  user.save

  # create loan base on user
  loan = FactoryGirl.create(:loan_with_property, user: user)

  hud_estimate = loan.create_hud_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  hud_final = loan.create_hud_final(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  loan_estimate = loan.create_loan_estimate(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  loan_estimate = loan.create_uniform_residential_lending_application(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))

  property = loan.property
  appraisal_report = property.create_appraisal_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  mortgage_statement = property.create_mortgage_statement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  purchase_agreement = property.create_purchase_agreement(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))
  risk_report = property.create_risk_report(attachment: File.new(Rails.root.join 'spec', 'files', 'sample.docx'))

end

# create staff user
if User.where(email: 'le_hoang0306@yahoo.com.vn').blank?
  user = User.new(email: 'le_hoang0306@yahoo.com.vn', password: '12345678',
    password_confirmation: '12345678')
  user.skip_confirmation!
  user.save
  loan_member = user.build_loan_member(employee_id:1) #fake data
  loan_member.save
  # create loan base on user
  # loan = FactoryGirl.create(:loan_with_property, user: user)
end

# if Template.where(name: 'Loan Estimation').blank?
#   base = Docusign::Base.new
#   template = base.create_template_object_from_name("Loan Estimation")
# end
