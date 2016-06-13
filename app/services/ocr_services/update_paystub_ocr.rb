module OcrServices
  #
  # Class UpdatePaystubOcr provides update OCR's log
  # We need to know which paystub was scanned by OCR (we have two paystubs)
  #
  #
  class UpdatePaystubOcr
    attr_accessor :data, :borrower_id, :ocr_data, :order_of_paystub

    def initialize(data, borrower_id)
      @data = data
      @borrower_id = borrower_id
      @ocr_data = Ocr.where(borrower_id: borrower_id).last
      @order_of_paystub = data[:order_of_paystub]
    end

    def call
      clean_data
      return create_new_ocr_record if @ocr_data.nil?

      if order_of_paystub == 1
        update_first_paystub_to_ocr
      elsif order_of_paystub == 2
        update_second_paystub_to_ocr
      end

      ocr_data
    end

    def clean_data
      if @data[:current_salary].present? && @data[:current_salary].is_a?(String)
        @data[:current_salary] = @data[:current_salary].delete(",").to_f
      end

      if @data[:ytd_salary].present? && @data[:ytd_salary].is_a?(String)
        @data[:ytd_salary] = @data[:ytd_salary].delete(",").to_f
      end
    end

    private

    def create_new_ocr_record
      Ocr.create(
        employer_name_1: data[:employer_name],
        address_first_line_1: data[:address_first_line],
        address_second_line_1: data[:address_second_line],
        period_beginning_1: data[:period_beginning],
        period_ending_1: data[:period_ending],
        current_salary_1: data[:current_salary],
        ytd_salary_1: data[:ytd_salary],
        current_earnings_1: data[:current_earnings],
        borrower_id: borrower_id
      )
    end

    def update_first_paystub_to_ocr
      ocr_data.update(
        employer_name_1: data[:employer_name],
        address_first_line_1: data[:address_first_line],
        address_second_line_1: data[:address_second_line],
        period_beginning_1: data[:period_beginning],
        period_ending_1: data[:period_ending],
        current_salary_1: data[:current_salary],
        ytd_salary_1: data[:ytd_salary],
        current_earnings_1: data[:current_earnings]
      )
    end

    def update_second_paystub_to_ocr
      ocr_data.update(
        employer_name_2: data[:employer_name],
        address_first_line_2: data[:address_first_line],
        address_second_line_2: data[:address_second_line],
        period_beginning_2: data[:period_beginning],
        period_ending_2: data[:period_ending],
        current_salary_2: data[:current_salary],
        ytd_salary_2: data[:ytd_salary],
        current_earnings_2: data[:current_earnings]
      )
    end
  end
end
