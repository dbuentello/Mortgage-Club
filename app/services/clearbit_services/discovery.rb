module ClearbitServices
  class Discovery
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
      # response sample: https://gist.github.com/tangnv/5fafc3c6ab1d738ba512

      return unless company_name.present?

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

      list_company_indexes = get_list_company_indexes(response_data["results"])

      update_company_contact(response_data["results"], list_company_indexes)
    end

    def update_company_contact(response_data, list_company_indexes)
      phone_info = nil
      address_info = nil

      list_company_indexes.each do |index|
        break if phone_info && address_info

        phone_info = get_phone_info(response_data[index]) unless phone_info
        address_info = response_data[index]["geo"] unless address_info
      end

      update_phone_info(phone_info)
      update_address_info(address_info)
    end

    def get_phone_info(response_data)
      phone = response_data["phone"]

      return phone if phone.present?
      return unless response_data["site"].present? && response_data["site"]["phoneNumbers"].present?

      response_data["site"]["phoneNumbers"][0]
    end

    def get_list_company_indexes(response_data)
      company_hash = {}

      response_data.each_with_index do |company, index|
        company_response = company_hash[company["location"]]

        if company_response.present?
          company_response[:count] += 1
          company_response[:indexes] << index
        else
          company_hash[company["location"]] = {
            count: 1,
            indexes: [index]
          }
        end
      end

      company_hash.max_by(&:count)[1][:indexes]
    end

    def update_phone_info(phone)
      return unless phone

      @company_info[:contact_name] = "HR Department"
      @company_info[:contact_phone_number] = format_phone(phone)
    end

    def update_address_info(address)
      return unless address

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

      "(#{phone[0, 3]}) #{phone[3, 3]}-#{phone[6, 4]}"
    end
  end
end
