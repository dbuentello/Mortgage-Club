require 'uri'
require 'net/http'
require "csv"

class UpdateQuotesLinkForContactService
  attr_accessor :agent

  def initialize
    @agent = Mechanize.new
  end

  def call
    csv_text = File.read("public/contact.csv")
    csv = CSV.parse(csv_text, headers: true)
    csv.each do |row|
      row = row.to_hash
      params = {
        "zip_code" => row["Zip"],
        "credit_score" => "740",
        "mortgage_purpose" => "refinance",
        "property_value" => row["Estimated Home Value"].delete(',').delete('$').to_f,
        "property_usage" => "primary_residence",
        "property_type" => "sfh",
        "mortgage_balance" => row["Estimated Current Mortgage Balance"].delete(',').delete('$').to_f,
        "down_payment" => ""
      }
      quote_query = QuoteQuery.new(query: params.to_json)

      next unless quote_query.save

      quote_url = "https://www.mortgageclub.co/quotes/#{quote_query.code_id}"

      url = URI("https://api.contactually.com/v2/contacts/#{row['Contact Id']}")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      response = http.request(request)

      contact_data = JSON.load(response.read_body)["data"]

      next unless contact_data.present?
      rate_quote_field = contact_data["custom_fields"].find { |field| field["field"]["id"] == "custom_field_91432" }

      if rate_quote_field
        rate_quote_field["value"] = quote_url
      else
        contact_data["custom_fields"] << {
          "value" => quote_url,
          "field" => {
            "id" => "custom_field_91432",
            "name" => "Rate Quote Link"
          }
        }
      end

      request = Net::HTTP::Patch.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      request.body = {
        "data" => contact_data
      }.to_json

      http.request(request)

      ap quote_url
      ap params
      ap row["Contact Id"]
    end
  end
end
