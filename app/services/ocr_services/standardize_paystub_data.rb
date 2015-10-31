require 'fuzzystringmatch'

module OcrServices
  class StandardizePaystubData
    attr_reader :ocr_data

    def initialize(borrower_id)
      @ocr_data = Ocr.where(borrower_id: borrower_id).last
      @jarow = FuzzyStringMatch::JaroWinkler.create(:pure)
    end

    def call
      return Rails.logger.error "Borrower #{borrower_id} does not have OCR data" if ocr_data.nil?

      {
        employer_name: employer_name,
        employer_full_address: employer_full_address,
        employer_street_address: employer_street_address,
        period: period,
        current_salary: salary,
        ytd_salary: ytd_salary
      }
    end

    def employer_name
      return if percentage_similarity(ocr_data.employer_name_1, ocr_data.employer_name_2) < 0.97

      (ocr_data.employer_name_1.length > ocr_data.employer_name_2.length) ? ocr_data.employer_name_1 : ocr_data.employer_name_2
    end

    def employer_full_address
      first_line = employer_address_line(ocr_data.address_first_line_1, ocr_data.address_first_line_2)
      second_line = employer_address_line(ocr_data.address_second_line_1, ocr_data.address_second_line_2)

      return first_line << " " << second_line if first_line.present? && second_line.present?
      return first_line if first_line.present?
      return second_line if second_line.present?
    end

    def employer_address_line(first_address, last_address)
      return if percentage_similarity(first_address, last_address) < 0.97

      (first_address.length > last_address.length) ? first_address : last_address
    end

    def period
      return "semimonthly" if semimonthly_frequency?
      return "biweekly" if biweekly_frequency?
      return "weekly" if weekly_frequency?
    end

    def salary
      if valid_salary?(ocr_data.current_salary_1, ocr_data.current_salary_2)
        return (ocr_data.current_salary_1 > ocr_data.current_salary_2 ? ocr_data.current_salary_1 : ocr_data.current_salary_2).ceil
      end

      if valid_salary?(ocr_data.current_earnings_1, ocr_data.current_earnings_2)
        return (ocr_data.current_earnings_1 > ocr_data.current_earnings_2 ? ocr_data.current_earnings_1 : ocr_data.current_earnings_2).ceil
      end
    end

    def ytd_salary
      return unless valid_salary?(ocr_data.ytd_salary_1, ocr_data.ytd_salary_2)

      (ocr_data.ytd_salary_1 > ocr_data.ytd_salary_2 ? ocr_data.ytd_salary_1 : ocr_data.ytd_salary_2).ceil
    end

    def employer_street_address
      first_line = employer_address_line(ocr_data.address_first_line_1, ocr_data.address_first_line_2)
      return first_line if first_line.present?
    end

    private

    def percentage_similarity(first_str, last_str)
      return 0 if first_str.nil? || last_str.nil?

      @jarow.getDistance(first_str, last_str)
    end

    def date_of_month(datetime)
      return 0 if datetime.nil?

      datetime.strftime("%d").to_i
    end

    def date_is_end_of_month?(datetime)
      return false if datetime.nil?

      datetime.to_i == datetime.end_of_month.to_i
    end

    def semimonthly_frequency?
      (date_of_month(ocr_data.period_ending_1) == 15 || date_is_end_of_month?(ocr_data.period_ending_1)) &&
      (date_of_month(ocr_data.period_ending_2) == 15 || date_is_end_of_month?(ocr_data.period_ending_2))
    end

    def biweekly_frequency?
      date_of_month(ocr_data.period_ending_1) - date_of_month(ocr_data.period_beginning_1) == 13 &&
      date_of_month(ocr_data.period_ending_2) - date_of_month(ocr_data.period_beginning_2) == 13
    end

    def weekly_frequency?
      date_of_month(ocr_data.period_ending_1) - date_of_month(ocr_data.period_beginning_1) == 6 &&
      date_of_month(ocr_data.period_ending_2) - date_of_month(ocr_data.period_beginning_2) == 6
    end

    def valid_salary?(first_salary, last_salary)
      ratio = first_salary.to_f / last_salary.to_f
      0.95 <= ratio && ratio <= 1.05
    end
  end
end
