require "securerandom"

class QuoteQuery < ActiveRecord::Base
  validates :code_id, presence: true
  validates :query, presence: true
  before_validation :generate_code_id

  def generate_code_id
    return if self.code_id.present?

    while self.code_id.blank?
      random_string = "MC#{SecureRandom.urlsafe_base64(4)}"
      self.code_id = random_string if QuoteQuery.where(code_id: random_string).empty?
    end
  end
end
