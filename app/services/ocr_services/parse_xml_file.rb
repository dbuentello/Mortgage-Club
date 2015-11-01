module OcrServices
  class ParseXmlFile
    include HTTParty

    def self.call(raw_post)
      message = JSON.parse(raw_post["Message"])
      return {} unless message["Records"].present?

      record = message["Records"].first
      bucket_name = record["s3"]["bucket"]["name"]
      key = record["s3"]["object"]["key"]
      file_name = File.basename key, '.xml'
      doc_type = file_name.split('-').first

      s3 = AWS::S3::Client.new
      response = s3.get_object({bucket_name: bucket_name, key: key})

      return {} if response.blank?

      data = Nokogiri::XML(response.data[:data])

      {
        employer_name: data.at_css('_EmployerName').content,
        address_first_line: data.at_css('_EmployerAddressFirstLine').content,
        address_second_line: data.at_css('_EmployerAddressSecondLine').content,
        period_beginning: data.at_css('_PeriodBeginning').content,
        period_ending: data.at_css('_PeriodEnding').content,
        current_salary: data.at_css('_CurrentSalary').content,
        ytd_salary: data.at_css('_YTDSalary').content,
        current_earnings: data.at_css('_CurrentEarnings').content,
        borrower_id: borrower_id = file_name.gsub("#{doc_type}-", ''),
        order_of_paystub: get_order_of_paystub(doc_type)
      }
    end

    def self.get_order_of_paystub(doc_type)
      return 1 if doc_type == 'FirstPaystub'
      return 2 if doc_type == 'SecondPaystub'
    end
  end
end