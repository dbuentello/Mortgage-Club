require 'securerandom'

class OcrParseService
  include HTTParty

  def self.call(raw_post)
    message = JSON.parse(raw_post["Message"])
    record = message["Records"].first
    bucket_name = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]

    s3 = AWS::S3::Client.new
    response = s3.get_object({bucket_name: bucket_name, key: key})
    doc = Nokogiri::XML(response.data[:data])
    # doc.css('_EmployerName').first.content
  end
end
