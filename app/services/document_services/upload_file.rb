module DocumentServices
  class UploadFile
    attr_accessor :subject_class, :document_klass, :foreign_key_name, :foreign_key_id, :current_user, :params

    def initialize(args)
      @subject_class = args[:subject_class_name].constantize
      @document_klass = args[:document_klass_name].constantize
      @foreign_key_name = args[:foreign_key_name]
      @foreign_key_id = args[:foreign_key_id]
      @current_user = args[:current_user]
      @params = args[:params]
    end

    def call
      document = document_klass.where(foreign_key_name => foreign_key_id).last
      subject = subject_class.find(foreign_key_id)

      if document.present? && !document.other_report?
        document.attachment = params[:file]
        document.attachment_file_name = "#{document_klass}-#{foreign_key_id}#{file_extension}"
        document.original_filename = params[:original_filename]
        document.save
      else
        document = document_klass.new(
          attachment: params[:file],
          original_filename: params[:file].original_filename,
          attachment_file_name: "#{document_klass}-#{foreign_key_id}#{file_extension}",
          description: params[:description],
          foreign_key_name => subject.id
        )
        document.owner = current_user
        document.save
      end
      document
    end

    def file_extension
      File.extname(params[:file].original_filename)
    end
  end
end