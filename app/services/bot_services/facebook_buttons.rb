module BotServices
  class FacebookButtons
    def self.btn_purpose_types
      [
        {
          type: "postback",
          title: "Purchase",
          payload: "purchase"
        }, {
          type: "postback",
          title: "Refinance",
          payload: "refinance"
        }
      ]
    end

    def self.btn_welcome
      [
        {
          type: "postback",
          title: "Get a rate quote",
          payload: "get_rate_quote"
        }, {
          type: "postback",
          title: "Should I refinance?",
          payload: "get_refinance"
        }
      ]
    end

    def self.btn_usage
      [
        {
          type: "postback",
          title: "Primary Residence",
          payload: "primary_residence"
        }, {
          type: "postback",
          title: "Vacation Home",
          payload: "vacation_home"
        }, {
          type: "postback",
          title: "Rental Property",
          payload: "rental_property"
        }
      ]
    end

    def self.btn_property_types
      [
        {
          type: "postback",
          title: "Single Family Home",
          payload: "sfh"
        }, {
          type: "postback",
          title: "Multi-Family",
          payload: "multi_family"
        }, {
          type: "postback",
          title: "Condo/Townhouse",
          payload: "condo"
        }
      ]
    end
  end
end
