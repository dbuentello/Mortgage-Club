module ContactuallyServices
  class AddOrUpdateContact
    attr_reader :email, :purpose, :first_name, :last_name, :quote_url
    PURCHASE_BUCKET_ID = "bucket_57404009"
    REFINANCE_BUCKET_ID = "bucket_58093202"

    def initialize(params)
      quote = QuoteQuery.find_by_code_id(params[:code_id])
      quote_query = JSON.load quote.query

      @purpose = quote_query["mortgage_purpose"]
      @email = params[:email]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @quote_url = "https://www.mortgageclub.co/quotes/#{params[:code_id]}"
    end

    def call
      contacts = old_contact

      if contacts.present?
        update_contact(contacts)
      else
        create_new_contact
      end
    end

    def old_contact
      url = URI("https://api.contactually.com/v2/contacts?q=#{email}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      response = http.request(request)

      JSON.load(response.read_body)["data"]
    end

    def data_for_create
      {
        "data" => {
          "first_name" => first_name,
          "last_name" => last_name,
          "email_addresses" => [
            {
              "label" => "Personal",
              "address" => email
            }
          ],
          "custom_fields" => [
            {
              "field" => {
                "id" => "custom_field_91432",
                "value" => "Rate Quote Link"
              },
              "value" => quote_url
            }
          ]
        }
      }
    end

    def create_new_contact
      url = URI("https://api.contactually.com/v2/contacts")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      request.body = data_for_create.to_json

      response = http.request(request)
      contact = JSON.load(response.read_body)["data"]

      add_bucket(contact["id"]) if contact.present?
    end

    def update_contact(contacts)
      contact = contacts[0]
      rate_quote_field = contact["custom_fields"].find { |field| field["field"]["id"] == "custom_field_91432" }

      if rate_quote_field
        rate_quote_field["value"] = quote_url
      else
        contact["custom_fields"] << {
          "value" => quote_url,
          "field" => {
            "id" => "custom_field_90983",
            "name" => "Rate Quote"
          }
        }
      end

      url = URI("https://api.contactually.com/v2/contacts/#{contact['id']}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Patch.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      request.body = {
        "data" => contact
      }.to_json

      http.request(request)
    end

    def add_bucket(contact_id)
      url = URI("https://api.contactually.com/v2/contacts/#{contact_id}/buckets")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      request.body = {
        "data" => [
          {
            "id": purpose == "purchase" ? PURCHASE_BUCKET_ID : REFINANCE_BUCKET_ID
          }
        ]
      }.to_json

      http.request(request)
    end

    def delete_contact(contact_id)
      url = URI("https://api.contactually.com/v2/contacts/#{contact_id}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Delete.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'

      http.request(request)
    end
  end
end
