require "rails_helper"

describe ClearbitServices::Discovery do
  let!(:service) { ClearbitServices::Discovery.new("microsoft") }
  describe "#format_phone" do
    context "when phone is nil" do
      it "returns nil" do
        expect(service.format_phone(nil)).to be_nil
      end
    end

    context "when phone contains country number" do
      it "returns formatted phone" do
        expect(service.format_phone("+1 123-456-7890")).to eq("(123) 456-7890")
      end
    end

    context "when phone contains not country number" do
      it "returns formatted phone" do
        expect(service.format_phone("123-456-7890")).to eq("(123) 456-7890")
      end
    end
  end

  describe "#update_phone_info" do
    context "when phone is nil" do
      it "does not assign contact phone and contact name" do
        service.update_phone_info(nil)

        expect(service.company_info[:contact_name]).to be_nil
        expect(service.company_info[:contact_phone_number]).to be_nil
      end
    end

    context "with valid phone" do
      it "assigns new value for contact phone, contact name" do
        service.update_phone_info("+1 123-456-7890")

        expect(service.company_info[:contact_name]).to eq("HR Department")
        expect(service.company_info[:contact_phone_number]).to eq("(123) 456-7890")
      end
    end
  end

  describe "#update_address_info" do
    context "when address is nil" do
      it "does not assign street address, city, zip and state" do
        service.update_address_info(nil)

        expect(service.company_info[:street_address]).to be_nil
        expect(service.company_info[:city]).to be_nil
        expect(service.company_info[:state]).to be_nil
        expect(service.company_info[:zip]).to be_nil
      end
    end

    context "with valid address" do
      it "assigns new value for street address, city, zip and state" do
        address = {
          "streetNumber" => "123",
          "streetName" => "Silver Street",
          "city" => "New York",
          "postalCode" => "94103",
          "stateCode" => "CA"
        }

        service.update_address_info(address)

        expect(service.company_info[:street_address]).to eq("123 Silver Street")
        expect(service.company_info[:city]).to eq("New York")
        expect(service.company_info[:state]).to eq("CA")
        expect(service.company_info[:zip]).to eq("94103")
      end
    end
  end

  describe "#get_list_company_indexes" do
    context "with response data valid" do
      it "returns list index" do
        response_data = [
          {
            "location" => "123 Silver Street"
          },
          {
            "location" => "123 Gold Street"
          },
          {
            "location" => "123 Silver Street"
          }
        ]

        expect(service.get_list_company_indexes(response_data)).to eq([0, 2])
      end
    end
  end

  describe "#get_phone_info" do
    context "when response contains phone field" do
      it "returns phone" do
        response = {
          "phone" => "+1 123-456-7890"
        }

        expect(service.get_phone_info(response)).to eq("+1 123-456-7890")
      end
    end

    context "when response contains not phone field" do
      context "when response contains site field" do
        context "when site field contains phone numbers field" do
          it "returns phone" do
            response = {
              "site" => {
                "phoneNumbers" => [
                  "+1 123-456-7890"
                ]
              }
            }

            expect(service.get_phone_info(response)).to eq("+1 123-456-7890")
          end
        end

        context "when site field does not contain phone numbers field" do
          it "returns nil" do
            response = {
              "site" => {}
            }

            expect(service.get_phone_info(response)).to be_nil
          end
        end
      end

      context "when response does not contain site field" do
        it "returns nil" do
          response = {}

          expect(service.get_phone_info(response)).to be_nil
        end
      end
    end
  end

  describe "#read_company_info" do
    context "when response contains results field" do
      it "calls #get_list_company_indexes" do
        response = {
          "results" => [
            {
              "site" => {
                "url" => "http://microsoft.de",
                "title" => "Microsoft – Offizielle Homepage",
                "h1" => "",
                "metaDescription" => "",
                "metaAuthor" => "",
                "phoneNumbers" => [],
                "emailAddresses" => []
              },
              "location" => "1 Microsoft Way, Redmond, WA 98052, USA",
              "geo" => {
                "streetNumber" => "1",
                "streetName" => "Microsoft Way",
                "subPremise" => "",
                "city" => "Redmond",
                "postalCode" => "98052",
                "state" => "Washington",
                "stateCode" => "WA",
                "country" => "United States",
                "countryCode" => "US",
                "lat" => 47.6395831,
                "lng" => -122.128381
              },
              "phone": ""
            }
          ]
        }

        expect(service).to receive(:get_list_company_indexes).and_return([0])

        service.read_company_info(response)
      end

      it "calls #update_company_contact_function" do
        response = {
          "results" => [
            {
              "site" => {
                "url" => "http://microsoft.de",
                "title" => "Microsoft – Offizielle Homepage",
                "h1" => "",
                "metaDescription" => "",
                "metaAuthor" => "",
                "phoneNumbers" => [],
                "emailAddresses" => []
              },
              "location" => "1 Microsoft Way, Redmond, WA 98052, USA",
              "geo" => {
                "streetNumber" => "1",
                "streetName" => "Microsoft Way",
                "subPremise" => "",
                "city" => "Redmond",
                "postalCode" => "98052",
                "state" => "Washington",
                "stateCode" => "WA",
                "country" => "United States",
                "countryCode" => "US",
                "lat" => 47.6395831,
                "lng" => -122.128381
              },
              "phone": ""
            }
          ]
        }

        expect(service).to receive(:update_company_contact)

        service.read_company_info(response)
      end
    end

    context "when response does not contain results field" do
      it "returns nil" do
        response = {}

        expect(service.read_company_info(response)).to be_nil
      end
    end
  end

  describe "#call" do
    context "with valid company name" do
      it "returns status 200" do
        VCR.use_cassette("get status 200 from Clearbit") do
          service.call

          expect(service.response.status).to eq(200)
        end
      end
    end

    context "with invalid company name" do
      it "returns nil" do
        service.company_name = ""

        expect(service.call).to be_nil
      end
    end
  end
end
