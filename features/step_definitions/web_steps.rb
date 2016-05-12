Then(/^I should see page title as "(.*)"$/) do |title|
  expect(page).to have_title "#{title}"
end

Then(/^the radio with id "([^\"]+)" to be disabled$/) do |id|
  expect(page).to have_field(id, type: 'radio', disabled: true)
end

Then(/^I should( not)? see "([^"]*)" in the "([^"]*)" input$/) do |negate, content, labeltext|
  if negate
    expect(page).not_to have_field(labeltext, with: content)
  else
    expect(page).to have_field(labeltext, with: content)
  end
end

Then(/^I should see the avatar "(.+)"$/) do |image|
  # expect(page).to have_xpath("//img[contains(@src=\"/public/uploads/users/1/'#{image}\")]")
  expect(page).to have_xpath("//img[contains(@src,\"/uploads/users/1/#{image}\")]")
end

Then(/^I should not see the avatar "(.+)"$/) do |image|
  # expect(page).to have_xpath("//img[contains(@src=\"/public/uploads/users/1/'#{image}\")]")
  expect(page).not_to have_xpath("//img[contains(@src,\"/uploads/users/1/#{image}\")]")
end

When(/^a GET request is sent to "(.*?)"$/) do |url|
  visit url
end

When(/^I turn on delayed jobs$/) do
  Delayed::Worker.delay_jobs = true
end

When(/^I turn off delayed jobs$/) do
  Delayed::Worker.delay_jobs = false
  Devise::Async.enabled = false
end

When(/^I should see content as "(.*)"$/) do |content|
  expect(page).to have_selector("input[value='#{content}']")
end

Given(/^I wait for (\d+) seconds?$/) do |n|
  sleep(n.to_i)
end

When(/^I attach the file "([^\"]*)" to the hidden "([^\"]*)"$/) do |path, field|
  page.execute_script("document.getElementsByName('#{field}')[0].className = '';")
  page.execute_script("document.getElementsByName('#{field}')[0].setAttribute('style', 'display:block;')")
  patiently do
    attach_file(field, File.expand_path(path))
  end
end

When(/^I attach the file "([^\"]*)" to the avatar file input "([^\"]*)"$/) do |path, field|
  page.execute_script("document.getElementsByName('#{field}')[0].className = '';")
  page.execute_script("document.getElementsByName('#{field}')[0].setAttribute('style', 'position:relative; top:0;')")
  patiently do
    attach_file(field, File.expand_path(path))
  end
end

When(/^I set the value "([^\"]*)" to the hidden "([^\"]*)"$/) do |value, field|
  page.execute_script("document.getElementsByName('#{field}')[0].value = '#{value}';")
end

When(/^I click on a first "([^\"]+)"$/) do |className|
  first("#{className}").click
end

When(/^I am at loan management page$/) do
  many_steps %(
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with the loan above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      When I login as "testing@man.net" with password "secretpass"
        And I follow "Edit Application"
  )
end

When(/^I am at dashboard page$/) do
  many_steps %(
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the status "pending" and with the user above and with the closing above and with the monthly_payment "5356"
      And there is a loan_member_user_with_loan_member with the first name "Michael" and the last name "Gifford"
      And there is a property with the id "be69aefe-3946-4b85-9c54-58dd51306b1c" and with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with the loan above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" and the property id "be69aefe-3946-4b85-9c54-58dd51306b1c"
      And there is a document with the user above and with the document type "appraisal_report" and with the attachment file name "property-document-name" and with the subjectable type "Property" and the subjectable id "be69aefe-3946-4b85-9c54-58dd51306b1c"
      And there is a loan members title with the title "manager"
      And there is a loans members association with the loan above and with the loan member above
      And there is a loans members association with the loan above and with loan members title above
      And I login as "testing@man.net" with password "secretpass"
    Then I follow "Dashboard"
  )
end

When(/^I am at my loans page$/) do
  many_steps %(
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and with the first name "Billy" and with the last name "Tran"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with loan above
      And there is a loan_member_user_with_loan_member with the first name "Michael" and the last name "Gifford"
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      And there is a document with the user above and with the document type "appraisal_report" and with the attachment file name "property-document-name" and with the subjectable type "Property" and the subjectable id "be69aefe-3946-4b85-9c54-58dd51306b1c"
      And there is a loan members title with the title "manager"
      And there is a loans members association with the loan above and with the loan member above
      And there is a loans members association with the loan above and with the loan members title above
      And I login as "testing@man.net" with password "secretpass"
  )
end

When(/^I am at loan management page which has co-borrower$/) do
  many_steps %(
    Given there is a borrower_user_with_borrower with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
      And there is a closing with the name "Fake Name"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above
      And there is a secondary borrower cucumber with the loan above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with the loan above
      And there is a address with the street address "81458 Borer Falls" and the street address2 "Apt. 305" and the city "West Emiltown" and the state "Virginia" and the zip "9999" with the property above
      When I login as "testing@man.net" with password "secretpass"
        And I follow "Edit Application"
  )
end

When(/^I am at loan member dashboard$/) do
  many_steps %(
    Given there is a borrower_user_with_borrower with the email "john_doe@gmail.com" and with the first name "John" and the last name "Doe"
      And there is a closing with the name "Fake Name"
      And there is a lender with the name "Quickens Loan"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above and with the user above and with the lender above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with loan above
      And there is a loan_member_user_with_loan_member with the email "loan_member@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the first name "Mark" and the last name "Lim"
      And there is a loan members title with the title "sale"
      And there is a loans members association with the loan above and with the loan member above and with the loan members title above
      And there is a checklist_upload with the loan above
      And I login as "loan_member@gmail.com" with password "secretpass"
    Then I click link with div ".linkTypeReversed"
  )
end
When(/^I am at loan list page$/) do
  many_steps %(
    Given there is a borrower_user_with_borrower with the email "john_doe@gmail.com" and with the first name "John" and the last name "Doe"
      And there is a closing with the name "Fake Name"
      And there is a lender with the name "Quickens Loan"
      And there is a loan with the amount "500000" and with the num of months "24" and with the purpose "0" and with the user above and with the closing above and with the user above and with the lender above
      And there is a property with the purchase price "1000000" and with the usage "0" and with the is primary "1" and with the is subject "1" and with loan above
      And there is a loan_member_user_with_loan_member with the email "loan_member@gmail.com" and the password "secretpass" and the password confirmation "secretpass" and the first name "Mark" and the last name "Lim"
      And there is a loan members title with the title "sale"
      And there is a loans members association with the loan above and with the loan member above and with the loan members title above
      And there is a checklist_upload with the loan above
      And I login as "loan_member@gmail.com" with password "secretpass"
  )
end

When(/^I am at select rates page$/) do
  many_steps %(
    Given there is a loan completed
      And I login as "testing@man.net" with password "password"
      And I click on "Edit Application"
      And I click on "Save and Continue"
      And I click on "See my rates"
      And I should see "Preparing loan programs to display"
      And I should see "Sort by"
  )
end

When(/^I clear value in "(.*?)"$/) do |field|
  patiently do
    fill_in(field, with: '')
  end
end

Then(/^the  "(.*?)" field should contain "(.*?)"$/) do |field, value|
  field_labeled(field).value.should =~ /#{value}/
end

When(/^I press "([^\"]*)" in the modal "([^\"]*)"$/) do |text, modal|
  button = page.find(:xpath, "//div[contains(@id, '#{modal}')]//button[contains(., '#{text}')]")
  button.click
end

When(/^I click on "([^\"]*)" in the "([^\"]*)"$/) do |text, element|
  find(element, text: text).click
end

When(/^I drag the file "([^\"]*)" to "([^\"]*)"$/) do |file, field|
  page.execute_script("document.getElementsByName('#{field}')[0].className = '';")
  page.execute_script("document.getElementsByName('#{field}')[0].setAttribute('style', 'display:block;')")
  patiently do
    attach_file(field, File.expand_path(file))
  end
end

When(/^I select "([^\"]*)" from "([^\"]*)" at "([^\"]*)"$/) do |value, field, element|
  within(:css, element) do
    select(value, from: field)
  end
end
When(/^I select "([^\"]*)" at "([^\"]*)"$/) do |val, element|
  within(:css, element) do
    find("option[value=#{val}]").click
  end
end

When(/^I fill in "([^\"]*)" with "([^\"]*)" at "([^\"]*)"$/) do |field, value, element|
  within(:css, element) do
    fill_in(field, with: value)
  end
end

When(/^I fill the input has id "([^\"]*)" with "([^\"]*)"$/) do |id, value|
  find(id).set(value)
  # fill_in(element, with: value)
end

When(/^At "([^\"]*)" I clear value in "(.*?)"$/) do |element, field|
  within(:css, element) do
    patiently do
      fill_in(field, with: '')
    end
  end
end

When(/^I click link with div "(.*?)"$/) do |element|
  find(element).click
end

When(/^I check on checkbox "(.*?)"$/) do |element|
  page.execute_script("$('#{element}').click()")
end

When(/^I uncheck on checkbox "(.*?)"$/) do |element|
  page.execute_script("$('#{element}').click()")
end

When(/^I click on selectpicker "([^"]+)" and select "([^"]+)"$/) do |selector, value|
  patiently do
    find("button[data-id='#{selector}']").click
    find('.bootstrap-select .dropdown-menu ul li', text: value).click
  end
end

When(/^At first klass "([^\"]*)" I click link "(.*?)"$/) do |element, text|
  first(element).find("a", text: text).click
end
When(/^At first klass "([^\"]*)" I click button "(.*?)"$/) do |element, text|
  first(element).find("button", text: text).click
end
When(/^I scroll up to the top$/) do
  page.execute_script("window.scrollTo(100000, 0)")
  sleep(2)
end

When(/^I hover on first klass "(.*?)"$/) do |element|
  first(element).hover
end

When(/^I click on the element "([^"]+)"$/) do |selector|
  patiently do
    page.find(selector).click
  end
end
When(/^I click on the first element "([^"]+)"$/) do |selector|
  patiently do
    page.first(selector).click
  end
end

When(/^I cick on "([^\"]*)" within "([^\"]*)"$/) do |text, scope_selector|
  within(scope_selector) do
    contains_text = %{contains(., \"#{text}\")}
    # find the innermost selector that matches
    element = page.find(:xpath, ".//*[#{contains_text} and not (./*[#{contains_text}])]")
    element.click
  end
end
