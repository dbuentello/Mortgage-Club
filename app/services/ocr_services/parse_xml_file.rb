require 'securerandom'

module OcrServices
  class ParseXmlFile
    include HTTParty

    def self.call(raw_post)
      message = JSON.parse(raw_post["Message"])
      record = message["Records"].first
      bucket_name = record["s3"]["bucket"]["name"]
      key = record["s3"]["object"]["key"]
      file_name = File.basename key, '.xml'
      doc_type = file_name.split('-').first

      s3 = AWS::S3::Client.new
      response = s3.get_object({bucket_name: bucket_name, key: key})
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

      # borrower = Borrower.find_by_id(borrower_id)
      # # if borrower.present?
      #   if doc_type == 'FirstPaystub' or doc_type == 'SecondPaystub'
      #     update_paystub(data, borrower, doc_type)
      #   end
      # end
    end

    def self.get_order_of_paystub(doc_type)
      return 1 if doc_type == 'FirstPaystub'
      return 2 if doc_type == 'SecondPaystub'
    end
    # def self.update_paystub(data, borrower, doc_type)
    #   employer_name = data.at_css('_EmployerName').content
    #   address_first_line = data.at_css('_EmployerAddressFirstLine').content
    #   address_second_line = data.at_css('_EmployerAddressSecondLine').content
    #   period_beginning = data.at_css('_PeriodBeginning').content
    #   period_ending = data.at_css('_PeriodEnding').content
    #   current_salary = data.at_css('_CurrentSalary').content
    #   ytd_salary = data.at_css('_YTDSalary').content
    #   current_earnings = data.at_css('_CurrentEarnings').content

    #   ocr = borrower.ocr.present? ? borrower.ocr : borrower.create_ocr
    #   if doc_type == 'FirstPaystub'
    #     ocr.update(
    #       employer_name_1: employer_name,
    #       address_first_line_1: address_first_line,
    #       address_second_line_1: address_second_line,
    #       period_beginning_1: period_beginning,
    #       period_ending_1: period_ending,
    #       current_salary_1: current_salary,
    #       ytd_salary_1: ytd_salary,
    #       current_earnings_1: current_earnings
    #     )
    #   else
    #     ocr.update(
    #       employer_name_2: employer_name,
    #       address_first_line_2: address_first_line,
    #       address_second_line_2: address_second_line,
    #       period_beginning_2: period_beginning,
    #       period_ending_2: period_ending,
    #       current_salary_2: current_salary,
    #       ytd_salary_2: ytd_salary,
    #       current_earnings_2: current_earnings)
    #   end
    # end
  end
end

