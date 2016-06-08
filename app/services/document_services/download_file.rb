# download a file from S3
module DocumentServices
  class DownloadFile
    def self.call(document_id)
      file = Document.find(document_id)
      Amazon::GetUrlService.call(file.attachment, 10.seconds)
    end
  end
end
