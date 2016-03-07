FactoryGirl.define do
  factory :potential_rate_drop_user do
    email "MyString"
phone_number "MyString"
refinance_purpose 1
current_mortgage_balance "9.99"
current_mortgage_rate 1.5
estimate_home_value "9.99"
zip "MyString"
credit_score 1
send_as_email false
send_as_text_message false
  end

end
