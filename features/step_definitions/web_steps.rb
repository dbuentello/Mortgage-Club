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

When /^I turn on delayed jobs$/ do
  Delayed::Worker.delay_jobs = true
end

When /^I turn off delayed jobs$/ do
  Delayed::Worker.delay_jobs = false
end

When /^I should see content as "(.*)"$/ do |content|
  expect(page).to have_content("#{content}")
end

Given /^I wait for (\d+) seconds?$/ do |n|
  sleep(n.to_i)
end

When /^I attach the file "([^\"]*)" to the hidden "([^\"]*)"$/ do |path, field|
  page.execute_script("document.getElementsByName('#{field}')[0].className = '';")
  page.execute_script("document.getElementsByName('#{field}')[0].setAttribute('style', 'display:block;')")
  patiently do
    attach_file(field, File.expand_path(path))
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
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with the loan above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      When I login as "testing@man.net" with password "secretpass"
        And I follow "Dashboard"
      Then I follow "Edit Loan"
  }
end

When /^I am at dashboard page$/ do
  many_steps %{
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above
      And there is a loan_member_user_with_loan_member with the first name "Michael" and the last name "Gifford"
      And there is a property with the id "be69aefe-3946-4b85-9c54-58dd51306b1c" and with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with the loan above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" and the property id "be69aefe-3946-4b85-9c54-58dd51306b1c"
      And there is a document with the user above and with the document type "appraisal_report" and with the attachment file name "property-document-name" and with the subjectable type "Property" and the subjectable id "be69aefe-3946-4b85-9c54-58dd51306b1c"
      And there is a loans members association with the loan above and with the loan member above and with the title "sale"
      And there is a loans members association with the title "manager" and with the loan above
      And I login as "testing@man.net" with password "secretpass"
    Then I follow "Dashboard"
  }
end

When /^I am at my loans page$/ do
  many_steps %{
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and with the first name "Billy" and with the last name "Tran"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with loan above
      And there is a loan_member_user_with_loan_member with the first name "Michael" and the last name "Gifford"
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      And there is a document with the user above and with the document type "appraisal_report" and with the attachment file name "property-document-name" and with the subjectable type "Property" and the subjectable id "be69aefe-3946-4b85-9c54-58dd51306b1c"
      And there is a loans members association with the loan above and with the loan member above and with the title "sale"
      And there is a loans members association with the title "manager" and with the loan above
      And I login as "testing@man.net" with password "secretpass"
  }
end

When /^I am at loan member dashboard$/ do
  many_steps %{
    Given there is a borrower_user_with_borrower with the email "john_doe@gmail.com" and with the first name "John" and the last name "Doe"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above and with the user above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with loan above
      And there is a loan_member_user_with_loan_member with the email "loan_member@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the first name "Mark" and the last name "Lim"
      And there is a loans members association with the loan above and with the loan member above and with the title "sale"
      And there is a checklist_upload with the loan above
      And I login as "loan_member@gmail.com" with password "secretpass"
    Then I click on "Loan of John Doe (email: john_doe@gmail.com)"
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

When /^I press "([^\"]*)" in the modal "([^\"]*)"$/ do |text, modal|
  button = page.find(:xpath, "//div[contains(@id, '#{modal}')]//button[contains(., '#{text}')]")
  button.click
end

When /^I click on "([^\"]*)" in the "([^\"]*)"$/ do |text, element|
  find(element, text: text).click
end

When /^I drag the file "([^\"]*)" to "([^\"]*)"$/ do |file, field|
  page.execute_script("document.getElementsByName('#{field}')[0].className = '';")
  page.execute_script("document.getElementsByName('#{field}')[0].setAttribute('style', 'display:block;')")
  patiently do
    attach_file(field, File.expand_path(file))
  end
  draggable = page.find(".topMenu")
  droppable = page.find("##{field}")
  draggable.drag_to(droppable)
end

When /^I select "([^\"]*)" from "([^\"]*)" at "([^\"]*)"$/ do |value, field, element|
  within(:css, element) do
    select(value, from: field)
  end
end

When /^I fill in "([^\"]*)" with "([^\"]*)" at "([^\"]*)"$/ do |field, value, element|
  within(:css, element) do
    fill_in(field, with: value)
  end
end

When /^At "([^\"]*)" I clear value in "(.*?)"$/ do |element, field|
  within(:css, element) do
    patiently do
      fill_in(field, with: '')
    end
  end
end

When /^I click link with div "(.*?)"$/ do |element|
  find(element).click
end
