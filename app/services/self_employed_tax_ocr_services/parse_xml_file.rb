module SelfEmployedTaxOcrServices
  class ParseXmlFile
    def self.call(raw_post)
      # message = JSON.parse(raw_post["Message"])
      # return {} unless message["Records"].present?

      # record = message["Records"].first
      # bucket_name = record["s3"]["bucket"]["name"]
      # key = record["s3"]["object"]["key"]
      # file_name = File.basename key, '.xml'
      # doc_type = file_name.split('-').first

      # s3 = AWS::S3::Client.new
      # response = s3.get_object({bucket_name: bucket_name, key: key})

      # return {} if response.blank?

      # data = Nokogiri::XML(response.data[:data])

      data = File.open("sample_xml_self_employed_tax.xml") { |file| Nokogiri::XML(file) }

      {
        net_profit_or_loss: data.at_css('_NetProfitOrLoss').content.to_f,
        depletion: data.at_css('_Depletion').content.to_f,
        depreciation: data.at_css('_Depreciation').content.to_f,
        business_of_home: data.at_css('_BusinessOfYourHome').content.to_f,
        amortization: data.at_css('_Amortization').content.to_f
      }
    end
  end
end
