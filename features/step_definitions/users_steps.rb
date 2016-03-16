When(/^I click "(.*?)"/) do |link|
  click_link(link)
end

Transform(/^(-?\d+)$/).map(&:to_i)
