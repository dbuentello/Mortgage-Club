# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create user with its borrower
if User.where(email: 'lehoang1417@gmail.com').blank?
  user = User.new(email: 'lehoang1417@gmail.com', password: '12345678')
  user.build_borrower(first_name: 'hoang', last_name: 'le')
  user.skip_confirmation!
  user.save

  # create loan base on user
  loan = FactoryGirl.create(:loan_with_property, user: user)
end

if Template.where(name: 'Loan Estimation').blank?
  base = Docusign::Base.new
  template = base.create_template_object_from_name("Loan Estimation")

  # TODO: add file from google drive, now is from local
end

