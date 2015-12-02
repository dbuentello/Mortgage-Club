module DocumentServices
  class RemoveFile
    def self.call(document_id)
      file = Document.find(document_id)
      file.destroy
      file.destroyed?
    end
  end
end