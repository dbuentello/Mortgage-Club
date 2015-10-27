require 'securerandom'

class OcrParseService
  include HTTParty

  def self.call(raw_post)
    message = JSON.parse(raw_post["Message"])
    record = message["Records"].first
    bucket_name = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]

    s3 = AWS::S3::Client.new
    response = s3.get_object({bucket_name: bucket_name, key: key})
    data = Nokogiri::XML(response.data[:data])
    update_data(data)
  end

  def self.update_data(data)
    employer_name = data.at_css('_EmployerName').content
    address_first_line = data.at_css('_EmployerAddressFirstLine').content
    address_second_line = data.at_css('_EmployerAddressSecondLine').content
    period_beginning = data.at_css('_PeriodBeginning').content
    period_ending = data.at_css('_PeriodEnding').content
    current_salary = data.at_css('_CurrentSalary').content
    ytd_salary = data.at_css('_YTDSalary').content
    current_earnings = data.at_css('_CurrentEarnings').content
    pay_frequency = 'monthly'

    if period_beginning.present? and period_ending.present?
      period_beginning = Date.strptime(period_beginning, "%m/%d/%Y")
      period_ending = Date.strptime(period_ending, "%m/%d/%Y")
    end
  end
end
