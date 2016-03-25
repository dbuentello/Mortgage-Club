module ClearbitServices
  class DiscoveryApi
    attr_accessor :company_name, :company_info, :response

    def initialize(company_name)
      @company_name = company_name
      @company_info = {
        contact_name: nil,
        contact_phone_number: nil,
        city: nil,
        state: nil,
        street_address: nil,
        zip: nil
      }
      @response = []
    end

    def call
      url = "https://discovery.clearbit.com/v1/companies/search?query=and:(name:'#{company_name}' country:us)"
      connection = Faraday.new(url: url)
      connection.basic_auth(ENV['CLEARBIT_KEY'], "")
      @response = connection.get

      read_company_info(JSON.parse(response.body)) if success?

      company_info
    end

    def success?
      response.status == 200
    end

    def read_company_info(response_data)
      return unless response_data["results"].present?

      read_phone_info(response_data)
      read_address_info(response_data)
    end

    def read_phone_info(response_data)
      @company_info[:contact_phone_number] = format_phone(response_data["phone"])
      @company_info[:contact_name] = "HR Department"
      return if response_data["phone"].present?

      @company_info[:contact_name] = nil
      return unless response_data["results"].last["site"].present?
      return unless response_data["results"].last["site"]["phoneNumbers"].present?

      @company_info[:contact_name] = "HR Department"
      @company_info[:contact_phone_number] = format_phone(response_data["results"].last["site"]["phoneNumbers"][0])
    end

    def read_address_info(address)
      @company_info[:street_address] = [address["streetNumber"], address["streetName"]].compact.join(" ")
      @company_info[:city] = address["city"]
      @company_info[:zip] = address["postalCode"]
      @company_info[:state] = address["stateCode"]
    end

    def format_phone(phone)
      # input phone "+1 123-456-7890"
      # output phone "(123) 456-7890"

      return unless phone

      phone = phone.gsub(/\D/, '')
      phone = phone[1..-1] if phone.size == 11 && phone[0] == 1.to_s

      "(#{phone[0,3]}) #{phone[3,3]}-#{phone[6,4]}"
    end
  end
end
