require "rails_helper"

describe OcrParseService do
  before(:each) do
    AWS.config(access_key_id: ENV['AWS_ACCESS_KEY_ID'], secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], region: 'us-west-2')

    @raw_post = {
      "Message" => {
        "Records" => [
          {
            "eventVersion" => "2.0",
            "eventSource" => "aws:s3",
            "awsRegion" => "us-west-2",
            "eventTime" => "2015-10-29T03:34:26.531Z",
            "eventName" => "ObjectCreated:Put",
            "userIdentity" => {
              "principalId" => "AKTQO7Y5H729B"
            },
            "requestParameters" => {
              "sourceIPAddress" => "14.167.113.143"
            },
            "responseElements" => {
              "x-amz-request-id" => "7C057E095999E4CF",
              "x-amz-id-2" => "+ooiYcrpxjT8+IDDFDaEO6gxBn2i3rqeHY+E8/5tDUBdQfTSeZV3sualcpMX9Ypt"
            },
            "s3" => {
              "s3SchemaVersion" => "1.0",
              "configurationId" => "ocrNotifications-Documents",
              "bucket" => {
                "name" => "dev-homieo",
                "ownerIdentity" => {
                  "principalId" => "AKTQO7Y5H729B"
                },
                "arn" => "arn:aws:s3:::dev-homieo"
              },
              "object" => {
                "key" => "ocr_results/SecondPaystub-2fde4a53-0f89-413b-9a02-dfdd9dec4da5.xml",
                "size" => "831",
                "eTag" => "9817a6d1fcb7d4a2feb3fea0907d66bd",
                "sequencer" => "00563193C27ADAF7F0"
              }
            }
          }
        ]
      }.to_json
    }

    allow_any_instance_of(AWS::S3::Client).to receive(:get_object).and_return("")
  end

  # it "parse a xml file" do
  #   expect_any_instance_of(AWS::S3::Client).to receive(:get_object)
  #   OcrParseService.call(@raw_post)
  # end

  it "call OcrParseService" do
    expect(OcrParseService.call(@raw_post)).to eq('2fde4a53-0f89-413b-9a02-dfdd9dec4da5')
  end
end