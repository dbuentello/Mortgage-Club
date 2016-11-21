module ContactuallyServices
  class AddOrUpdateInteraction
    attr_reader :email, :content

    def initialize(email, action_name)
      @content = action_name == "open" ? "Client has opened rate quote email." : "Client has clicked on their customized rate quote link."
      @email = email
    end

    def call
      contacts = old_contact
      add_interaction(contacts) if contacts.present?
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

    def add_interaction(contacts)
      contact = contacts[0]
      body = {
        "data" => {
          "body" => content,
          "initiated_by_contact" => false,
          "subject" => "Tracking Email",
          "type" => "email",
          "participants" => [
            {
              "contact_id": contact["id"]
            }
          ]
        }
      }

      url = URI("https://api.contactually.com/v2/interactions")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/json'
      request["authorization"] = 'Bearer 6e1s4my4seaxlzhacmwv5ja9tp1798cw'
      request.body = body.to_json

      http.request(request)
    end
  end
end
