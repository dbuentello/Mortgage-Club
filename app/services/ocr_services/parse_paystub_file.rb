module OcrServices
  class ParsePaystubFile

    def self.call(raw_post)
      {
        employer_name: raw_post[:employer_name],
        address_first_line: raw_post[:address_first_line],
        address_second_line: raw_post[:address_second_line],
        period_beginning: raw_post[:period_beginning],
        period_ending: raw_post[:period_ending],
        current_salary: raw_post[:current_salary],
        ytd_salary: raw_post[:ytd_salary],
        current_earnings: raw_post[:current_earnings],
        borrower_id: raw_post[:borrower_id],
        order_of_paystub: get_order_of_paystub(raw_post[:doc_type])
      }
    end

    def self.get_order_of_paystub(doc_type)
      return 1 if doc_type == 'FirstPaystub'
      return 2 if doc_type == 'SecondPaystub'
    end
  end
end
