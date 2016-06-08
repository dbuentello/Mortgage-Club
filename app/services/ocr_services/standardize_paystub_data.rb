require 'fuzzystringmatch'

module OcrServices
  #
  # Class StandardizePaystubData provides standardlizing OCR's data.
  # standardlize employer name, employer full address, employer street address, period, salary and ytd_salary.
  #
  #
  class StandardizePaystubData
    attr_reader :ocr_data, :borrower_id

    def initialize(borrower_id)
      @borrower_id = borrower_id
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
      ocr_data.employer_name_1 # demo purpose only

      # return if percentage_similarity(ocr_data.employer_name_1, ocr_data.employer_name_2) < 0.97

      # (ocr_data.employer_name_1.length > ocr_data.employer_name_2.length) ? ocr_data.employer_name_1 : ocr_data.employer_name_2
    end

    def employer_full_address
      # first_line = employer_address_line(ocr_data.address_first_line_1, ocr_data.address_first_line_2)
      # second_line = employer_address_line(ocr_data.address_second_line_1, ocr_data.address_second_line_2)
      first_line = ocr_data.address_first_line_1 # demo purpose only
      second_line = ocr_data.address_second_line_1 # demo purpose only

      return first_line << " " << second_line if first_line.present? && second_line.present?
      return first_line if first_line.present?
      return second_line if second_line.present?
    end

    #
    # Use FuzzyStringMatch to compare two strings.
    # Return nil if these two string have score lass then 0.97
    #
    # @param [<type>] first_address <description>
    # @param [<type>] last_address <description>
    #
    # @return [<type>] <description>
    #
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
      ocr_data.current_salary_1 # demo purpose only

      # if valid_salary?(ocr_data.current_salary_1, ocr_data.current_salary_2)
      #   return (ocr_data.current_salary_1 > ocr_data.current_salary_2 ? ocr_data.current_salary_1 : ocr_data.current_salary_2).ceil
      # end

      # if valid_salary?(ocr_data.current_earnings_1, ocr_data.current_earnings_2)
      #   return (ocr_data.current_earnings_1 > ocr_data.current_earnings_2 ? ocr_data.current_earnings_1 : ocr_data.current_earnings_2).ceil
      # end
    end

    def ytd_salary
      ocr_data.ytd_salary_1 # demo purpose only

      # return unless valid_salary?(ocr_data.ytd_salary_1, ocr_data.ytd_salary_2)

      # (ocr_data.ytd_salary_1 > ocr_data.ytd_salary_2 ? ocr_data.ytd_salary_1 : ocr_data.ytd_salary_2).ceil
    end

    def employer_street_address
      ocr_data.address_first_line_1 # demo purpose only

      # first_line = employer_address_line(ocr_data.address_first_line_1, ocr_data.address_first_line_2)
      # return first_line if first_line.present?
    end

    private

    def percentage_similarity(first_str, last_str)
      return 0 if first_str.nil? || last_str.nil?

      @jarow.getDistance(first_str, last_str)
    end

    def date_is_end_of_month?(datetime)
      return false if datetime.nil?

      datetime.end_of_day.to_i == datetime.end_of_month.to_i
    end

    def semimonthly_frequency?
      # demo purpose only
      (date_of_month(ocr_data.period_ending_1) == 15 || date_is_end_of_month?(ocr_data.period_ending_1))

      # (date_of_month(ocr_data.period_ending_1) == 15 || date_is_end_of_month?(ocr_data.period_ending_1)) &&
      # (date_of_month(ocr_data.period_ending_2) == 15 || date_is_end_of_month?(ocr_data.period_ending_2))
    end

    def biweekly_frequency?
      # demo purpose only
      ocr_data.period_ending_1.to_i - ocr_data.period_beginning_1.to_i == thirteen_days

      # ocr_data.period_ending_1.to_i - ocr_data.period_beginning_1.to_i == thirteen_days &&
      # ocr_data.period_ending_2.to_i - ocr_data.period_beginning_2.to_i == thirteen_days
    end

    def weekly_frequency?
      # demo purpose only
      ocr_data.period_ending_1.to_i - ocr_data.period_beginning_1.to_i == six_days

      # ocr_data.period_ending_1.to_i - ocr_data.period_beginning_1.to_i == six_days &&
      # ocr_data.period_ending_2.to_i - ocr_data.period_beginning_2.to_i == six_days
    end

    def valid_salary?(first_salary, last_salary)
      ratio = first_salary.to_f / last_salary.to_f
      0.95 <= ratio && ratio <= 1.05
    end

    def date_of_month(datetime)
      return 0 if datetime.nil?

      datetime.strftime("%d").to_i
    end

    def thirteen_days
      13 * 86400
    end

    def six_days
      6 * 86400
    end
  end
end
