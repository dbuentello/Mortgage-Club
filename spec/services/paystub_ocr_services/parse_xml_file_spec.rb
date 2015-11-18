require "rails_helper"

describe PaystubOcrServices::ParseXmlFile do
  before(:each) do
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
                "key" => "ocr_results/TestSecondPaystub-2fde4a53-0f89-413b-9a02-dfdd9dec4da5.xml",
                "size" => "831",
                "eTag" => "9817a6d1fcb7d4a2feb3fea0907d66bd",
                "sequencer" => "005634F6811633C495"
              }
            }
          }
        ]
      }.to_json
    }
  end

  it "call OcrParseService" do
    VCR.use_cassette("get ocr result xml file", :record => :new_episodes) do
      response = PaystubOcrServices::ParseXmlFile.call(@raw_post)
      expect(response).to eq(
        {
          :employer_name => "BRIAN R FONG DDS INC",
          :address_first_line => "3426 MURDOCH DR",
          :address_second_line => "Palo Alto CA 94306",
          :period_beginning => "4/1/2015",
          :period_ending => "4/30/2015",
          :current_salary => "7916.67",
          :ytd_salary => "63333.36",
          :current_earnings => "",
          :borrower_id => "2fde4a53-0f89-413b-9a02-dfdd9dec4da5",
          :order_of_paystub => nil,
        }
      )
    end
  end
end