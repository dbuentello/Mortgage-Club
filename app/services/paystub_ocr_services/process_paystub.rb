module PaystubOcrServices
  class ProcessPaystub
    def self.call(raw_post)
      data = PaystubOcrServices::ParseXmlFile.call(raw_post)
      return if data.empty?

      borrower_id = data[:borrower_id]
      borrower = Borrower.find_by_id(borrower_id)

      return if borrower.nil?

      paystub_ocr = PaystubOcrServices::UpdatePaystubOcr.new(data, borrower_id).call
      # if paystub_ocr.saved_two_paystub_result? # demo purpose only
      standardized_data = PaystubOcrServices::StandardizePaystubData.new(borrower_id).call
      PaystubOcrServices::UpdateEmployment.new(standardized_data, borrower_id).call if standardized_data.present?
      # end
    end
  end
end