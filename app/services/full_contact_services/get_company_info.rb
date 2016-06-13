# get company info from FullContact API
module FullContactServices
  class GetCompanyInfo
    attr_reader :domain
    attr_accessor :company_info, :response

    def initialize(domain)
      @domain = domain
      @company_info = {
        contact_name: "",
        contact_phone_number: "",
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

      company_info
    end

    def success?
      response.status == 200
    end

    def read_company_info(response_data)
      return unless response_data["contactInfo"].present?

      read_phone_info(response_data["contactInfo"]["phoneNumbers"]) if response_data["contactInfo"]["phoneNumbers"].present?
      read_address_info(response_data["contactInfo"]["addresses"]) if response_data["contactInfo"]["addresses"].present?
    end

    def read_phone_info(phones)
      phone = phones[0]

      @company_info[:contact_name] = "HR Department"
      @company_info[:contact_phone_number] = phone["number"].to_s
    end

    def read_address_info(addresses)
      address = addresses[0]
      state = address["region"].present? ? address["region"]["code"] : nil

      @company_info[:street_address] = address["addressLine1"].to_s
      @company_info[:city] = address["locality"].to_s
      @company_info[:zip] = address["postalCode"].to_s
      @company_info[:state] = state.to_s
    end
  end
end
