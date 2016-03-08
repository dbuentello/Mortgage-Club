FactoryGirl.define do
  factory :potential_rate_drop_user do
    email "MyString"
    phone_number "2313213"
    refinance_purpose "lower_rate"
    current_mortgage_balance "9.99"
    current_mortgage_rate 1.5
    estimated_home_value "9.99"
    zip "MyString"
    credit_score 1
    send_as_email false
    send_as_text_message false
  end

end
