module CompletedLoanServices
  class Base
    attr_accessor :loan

    def self.address_completed?(address)
      components = [
        address.street_address,
        address.street_address2,
        address.city,
        address.state
      ].compact.reject{|x| x.blank?}

      txtAddress = components.empty? ? address.full_text : "#{components.join(', ')} #{address.zip}"

      txtAddress.present?
    end
  end
end
