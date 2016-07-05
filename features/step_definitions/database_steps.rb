When(/^I create a borrower address with user email "(.*?)"/) do |user_email|
  user = User.where(email: user_email).first
  borrower = user.create_borrower

  address = borrower.borrower_addresses.build(
    address_attributes: {
      street_address: "1722 Silver Meadow Way",
      street_address2: "Apt. 305",
      city: "Sacramento",
      state: "CA",
      zip: "95829",
      full_text: "1722 Silver Meadow Way, Sacramento, CA 95829"
    }
  )
  address.save
end
