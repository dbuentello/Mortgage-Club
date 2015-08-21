module DocumentServices
  class DownloadFile
    attr_reader :document_klass, :document_id

    def initialize(document_klass_name, document_id)
      @document_klass = document_klass_name.constantize
      @document_id = document_id
    end

    def call
      file = document_klass.find(document_id)
      url = Amazon::GetUrlService.call(file.attachment)
    end
  end
end