module FullContactServices
  class GetCompanyInfo
    attr_reader :domain
    attr_accessor :contact_name, :contact_phone_number, :company_address, :response

    def initialize(domain)
      @domain = domain
      @contact_name = ""
      @contact_phone_number = ""
      @company_address = {
        city: "",
        state: "",
        street_address: "",
        zip: ""
      }
      @response = []
    end

    def call
      url = "https://api.fullcontact.com/v2/company/lookup.json?apiKey=#{ENV['FULL_CONTACT_KEY']}&domain=#{domain}"
      connection = Faraday.new(url: url)
      @response = connection.get

      read_company_info(JSON.parse(response.body)["organization"]) if success?

      {
        contact_name: contact_name,
        contact_phone_number: contact_phone_number,
        company_address: company_address
      }
    end

    def success?
      response.status == 200
    end

    def read_company_info(response_data)
      if response_data["contactInfo"].present?
        if response_data["contactInfo"]["phoneNumbers"].present?
          phone = response_data["contactInfo"]["phoneNumbers"][0]

          @contact_name = "HR Department"
          @contact_phone_number = phone["number"].to_s
        end

        if response_data["contactInfo"]["addresses"].present?
          address = response_data["contactInfo"]["addresses"][0]
          state = address["region"].present? ? address["region"]["code"] : nil

          @company_address = {
            street_address: address["addressLine1"].to_s,
            city: address["locality"].to_s,
            zip: address["postalCode"].to_s,
            state: state.to_s
          }
        end
      end
    end
  end
end
