require "cucumber/rspec/doubles"

When(/^I mock S3 object for "(.*)"$/) do |filename|
  s3_object = double()
  allow(s3_object).to receive(:url_for).and_return(Rails.root.join "spec", "files", filename)
  allow_any_instance_of(Paperclip::Attachment).to receive(:s3_object).and_return(s3_object)
end

When(/^I mock S3 object for all files$/) do
  s3_object = double()
  allow(s3_object).to receive(:url_for).and_return(Rails.root.join "spec", "files", "sample.pdf")
  allow_any_instance_of(Paperclip::Attachment).to receive(:s3_object).and_return(s3_object)
end
