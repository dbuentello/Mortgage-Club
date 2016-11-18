require 'uri'
require 'net/http'

class ContactuallyService
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def call
    old_contact
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

    contact_data = JSON.load(response.read_body)["data"]
  end
end
