module Amazon
  class GetUrlService
    def self.call(attachment, expires = BorrowerDocument::EXPIRE_VIEW_SECONDS.seconds, secure = true)
      s3_object = attachment.s3_object
      s3_object.url_for(:read, expires: expires, secure: secure).to_s
    end
  end
end