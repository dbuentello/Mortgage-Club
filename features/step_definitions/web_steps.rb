Then /^I should see page title as "(.*)"$/ do |title|
  expect(page).to have_title "#{title}"
end

Then /^I should( not)? see "([^"]*)" in the "([^"]*)" input$/ do |negate, content, labeltext|
  if negate
    expect(page).not_to have_field(labeltext, with: content)
  else
    expect(page).to have_field(labeltext, with: content)
  end
end

Then /^I should see the avatar "(.+)"$/ do |image|
  # expect(page).to have_xpath("//img[contains(@src=\"/public/uploads/users/1/'#{image}\")]")
  expect(page).to have_xpath("//img[contains(@src,\"/uploads/users/1/#{image}\")]")
end

Then /^I should not see the avatar "(.+)"$/ do |image|
  # expect(page).to have_xpath("//img[contains(@src=\"/public/uploads/users/1/'#{image}\")]")
  expect(page).not_to have_xpath("//img[contains(@src,\"/uploads/users/1/#{image}\")]")
end

When /^a GET request is sent to "(.*?)"$/ do |url|
  visit url
end

When /^I run the background jobs$/ do
  Delayed::Worker.new.work_off
end

When /^I should see content as "(.*)"$/ do |content|
  expect(page).to have_content("#{content}")
end

Given /^I wait for (\d+) seconds?$/ do |n|
  sleep(n.to_i)
end

When /^I attach the file "([^\"]*)" to the hidden "([^\"]*)"$/ do |path, field|
  patiently do
    attach_file(field, File.expand_path(path), visible: false)
  end
end

When /^I click on the (first|second|third)? "([^\"]+)"$/ do |index_in_words, text|
  index = {nil => 0, 'first' => 0, 'second' => 1, 'third' => 2}[index_in_words]
  contains_text = %{contains(., \"#{text}\")}
  # find the innermost selector that matches
  element = page.find(:xpath, "(.//*[#{contains_text} and not (./*[#{contains_text}])])[#{index}]")
  element.click
end

When /^I am at loan management page$/ do
  many_steps %{
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a property with the purchase price "1000000" and with the usage "0"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the property above and with the closing above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      When I login as "testing@man.net" with password "secretpass"
        And I follow "Dashboard"
      Then I follow "Edit Loan"
  }
end

When /^I am at dashboard page$/ do
  many_steps %{
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a property with the purchase price "1000000" and with the usage "0"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the property above and with the closing above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      And there is a lease agreement with the property above and with the attachment file name "property-document-name"
      And there is a first w2 with the borrower above and with the attachment file name "borrower-document-name"
      And there is a hud estimate with the loan above and with the attachment file name "loan-document-name"
      And there is a closing disclosure with the closing above and with the attachment file name "closing-document-name"
      And I login as "testing@man.net" with password "secretpass"
    Then I follow "Dashboard"
  }
end

When /^I clear value in "(.*?)"$/ do |field|
  patiently do
    fill_in(field, with: '')
  end
end

Then /^the  "(.*?)" field should contain "(.*?)"$/ do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end
