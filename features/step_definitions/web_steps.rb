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

Then /^I should see "(.*?)" thumbnail$/ do |image|
  expect(page).to have_selector("img[src$='thumb_#{image}']")
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