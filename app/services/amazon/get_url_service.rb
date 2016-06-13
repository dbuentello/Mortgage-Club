# genarate url of file from S3 and set expiration time.
module Amazon
  class GetUrlService
    def self.call(attachment, expires = Document::EXPIRE_VIEW_SECONDS.seconds, secure = true)
      s3_object = attachment.s3_object
      s3_object.url_for(:read, expires: expires, secure: secure, response_content_disposition: "attachment").to_s
    end
  end
end
