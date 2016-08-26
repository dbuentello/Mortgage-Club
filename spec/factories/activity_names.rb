FactoryGirl.define do
  factory :activity_name do
    notify_borrower_email false
notify_borrower_text false
notify_borrower_email_subject "MyText"
notify_borrower_email_body "MyText"
notify_borrower_text_body "MyText"
name "MyString"
  end

end
