module CreditReportServices
  #
  # Class CreateLiabilities provides creating liabilities from Equifax's response
  #
  #
  class SaveCreditReportAsPdf
    #
    # genarate credit report for borrower and co-borrower (in case we have co-borrower)
    #
    # @param [Loan] loan
    # @param [XML] response what we get from Equifax
    #
    #
    def self.call(loan, response)
      doc = Nokogiri::XML(response)
      save(loan, doc)
    end

    #
    # save credit report for borrower
    #
    # @param [Borrower] borrower <description>
    # @param [XML] response what we get from Equifax
    #
    # @return [<type>] <description>
    #
    def self.save(loan, doc)
      return if loan.borrower.nil?

      decoded_file = Base64.decode64(doc.css('EMBEDDED_FILE').to_s)
      file = Tempfile.new(['temp', '.pdf'])
      file.binmode
      file.write decoded_file
      file.rewind

      args = {
        subject_type: "Borrower",
        subject_id: loan.borrower.id,
        document_type: "other_borrower_report",
        current_user: loan.relationship_manager.present? ? loan.relationship_manager.user : nil,
        params: {
          file: file.present? ? file : nil,
          original_filename: "Credit report.pdf",
          description: "Credit report",
          document_id: loan.borrower.credit_report_file.present? ? loan.borrower.credit_report_file.id : nil
        }
      }
      DocumentServices::UploadFile.new(args).call.delay

      file.close
      file.unlink
    end
  end
end
