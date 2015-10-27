require 'securerandom'

class OcrParseService
  include HTTParty
  PATH = "#{Rails.root}/documents/"

  def self.call(raw_post)
    message = JSON.parse(raw_post["Message"])
    record = message["Records"].first
    bucket_name = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]
    region = record["awsRegion"]

    s3 = AWS::S3::Client.new
    extension = File.extname(key)
    file_name = PATH << random_name << extension

    response = s3.get_object({bucket_name: bucket_name, key: key})
    doc = Nokogiri::XML(response.data[:data])
    # doc.css('_EmployerName').first.content
  end

  def self.random_name
    SecureRandom.hex(8)
  end

end
