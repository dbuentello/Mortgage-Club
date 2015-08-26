module DocumentServices
  class DownloadFile
    def self.call(document_klass_name, document_id)
      document_klass = document_klass_name.constantize
      file = document_klass.find(document_id)
      url = Amazon::GetUrlService.call(file.attachment)
    end
  end
end