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

      document = Document.find_or_initialize_by(subjectable: subjectable, document_type: args[:document_type])
      document.attachment = params[:file]
      document.original_filename = params[:original_filename]
      document.description = params[:description]
      document.attachment_file_name = "#{args[:subject_type].constantize}-#{args[:subject_id]}#{file_extension}"
      document.user = current_user
      document.save
      document
    end

    private

    def subjectable
      @subjectable ||= args[:subject_type].constantize.find_by_id(args[:subject_id])
    end

    def file_extension
      File.extname(params[:file].original_filename)
    end
  end
end
