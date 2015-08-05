module Amazon
  class GetUrlService
    attr_accessor :s3_object, :secure, :expires

    def initialize(s3_object, expires = Document::EXPIRE_VIEW_SECONDS.seconds, secure = true)
      @s3_object = s3_object
      @expires = expires
      @secure = secure
    end

    def call
      s3_object.url_for(:read, expires: expires, secure: secure).to_s
    end
  end
end