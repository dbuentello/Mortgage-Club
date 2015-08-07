When(/^I create a borrower address with user email "(.*?)"/) do |user_email|
  user = User.where(email: user_email).first
  borrower = user.create_borrower

  byebug

  address = borrower.borrower_addresses.build({
    address_attributes: {
      street_address: "81458 Borer Falls",
      street_address2: "Apt. 305",
      city: "West Emiltown",
      state: "Virginia",
      zip: "9999"
    }
  })
  address.save
end
