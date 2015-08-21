module DocumentServices
  class UploadFile
    attr_reader :subject_class, :document_klass, :document_type,
                :foreign_key, :foreign_key_id, :current_user, :params

    def initialize(args)
      @subject_class = args[:subject_class].constantize
      @document_klass = args[:document_klass].constantize
      @document_type = args[:document_type]
      @foreign_key = args[:foreign_key]
      @foreign_key_id = args[:foreign_key_id]
      @current_user = args[:current_user]
      @params = args[:params]
    end

    def call
      # document = document_klass.where(closing_id: params[:closing_id]).last
      document = document_klass.where(foreign_key => foreign_key_id).last
      subject = subject_class.find(foreign_key_id)

      if document.present? && !document.other_report?
        document.update(attachment: params[:file])
      else
        document = document_klass.new(
          attachment: params[:file],
          description: params[:description],
          foreign_key => subject.id
        )
        document.owner = current_user
        document.save
      end
    end
  end
end