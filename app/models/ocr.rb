class Ocr < ActiveRecord::Base
  belongs_to :borrower, foreign_key: 'borrower_id'

  def saved_first_paystub_result?
    current_salary_1.present? || employer_name_1.present?
  end

  def saved_two_paystub_result?
    (current_salary_1.present? && current_salary_2.present?) || (employer_name_1.present? && employer_name_2.present?)
  end
end
