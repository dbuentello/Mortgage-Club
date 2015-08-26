module DocumentServices
  class RemoveFile
    def self.call(document_klass_name, document_id)
      document_klass = document_klass_name.constantize
      file = document_klass.find(document_id)
      file.destroy
      file.destroyed?
    end
  end
end