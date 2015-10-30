module OcrServices
  class ProcessPaystub
    def self.call(raw_post)
      data = OcrServices::ParseXmlFile.call(raw_post)
      if data.present?
        borrower_id = data[:borrower_id]
        borrower = Borrower.find_by_id(borrower_id)
        if borrower.present?
          paystub_ocr = OcrServices::UpdatePaystubOcr.new(data, borrower_id).call
          if paystub_ocr.saved_two_paystub_result?
            standardized_data = OcrServices::StandardizePaystubData.new(borrower_id).call
            OcrServices::UpdateEmployment.new(standardized_data, borrower_id).call
          end
        end
      end
    end
  end
end