# upload file to S3.
module DocumentServices
  class UploadFile
    attr_accessor :subject, :current_user, :params, :args

    def initialize(args)
      @args = args
      @params = args[:params]
      @current_user = args[:current_user]
    end

    def call
      return false if args[:subject_type].blank?
      return false unless subjectable

      if other_document?(args[:document_type])
        if params[:document_id].present?
          document = Document.find(params[:document_id])
        else
          document = Document.new(subjectable: subjectable, document_type: args[:document_type])
        end
      else
        document = Document.find_or_initialize_by(subjectable: subjectable, document_type: args[:document_type])
      end

      unless attachment_file_name == "dummy.pdf"
        document.attachment = params[:file]
        document.attachment_file_name = attachment_file_name
        document.original_filename = params[:original_filename]
      end

      document.description = params[:description]
      document.user = current_user

      return document if document.save
    end

    private

    def subjectable
      @subjectable ||= args[:subject_type].constantize.find_by_id(args[:subject_id])
    end

    def file_extension
      File.extname(params[:file].original_filename)
    end

    def attachment_file_name
      if args[:document_type] == "first_paystub" || args[:document_type] == "second_paystub"
        attachment_file_name = "#{args[:document_type]}-#{args[:subject_type].constantize}-#{args[:subject_id]}#{file_extension}"
      else
        attachment_file_name = params[:original_filename]
      end
      attachment_file_name
    end

    def other_document?(document_type)
      return true if document_type == "other_borrower_report" || document_type == "other_loan_report" || document_type == "other_closing_report" || document_type == "other_property_report"

      false
    end
  end
end
