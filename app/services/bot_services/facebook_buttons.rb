module BotServices
  class FacebookButtons
    def self.btn_purpose_types
      [
        {
          content_type: "text",
          title: "Purchase",
          payload: "purchase"
        }, {
          content_type: "text",
          title: "Refinance",
          payload: "refinance"
        }
      ]
    end

    def self.btn_welcome
      [
        {
          content_type: "text",
          title: "Get a rate quote",
          payload: "get_rate_quote"
        }, {
          content_type: "text",
          title: "Should I refinance?",
          payload: "get_refinance"
        }
      ]
    end

    def self.btn_credit_score
      [
        {
          content_type: "text",
          title: "740+",
          payload: "740"
        },
        {
          content_type: "text",
          title: "720 - 739",
          payload: "720"
        },
        {
          content_type: "text",
          title: "700 - 719",
          payload: "700"
        },
        {
          content_type: "text",
          title: "680 - 699",
          payload: "680"
        },
        {
          content_type: "text",
          title: "660 - 679",
          payload: "660"
        }
      ]
    end

    def self.btn_usage
      [
        {
          content_type: "text",
          title: "Primary Residence",
          payload: "primary_residence"
        }, {
          content_type: "text",
          title: "Vacation Home",
          payload: "vacation_home"
        }, {
          content_type: "text",
          title: "Investment Property",
          payload: "investment_property"
        }
      ]
    end

    def self.btn_property_types
      [
        {
          content_type: "text",
          title: "Single Family Home",
          payload: "sfh"
        }, {
          content_type: "text",
          title: "Multi-Family",
          payload: "multi_family"
        }, {
          content_type: "text",
          title: "Condo/Townhouse",
          payload: "condo"
        }
      ]
    end

    def self.btn_down_payment
      [
        {
          content_type: "text",
          title: "10%",
          payload: "10"
        }, {
          content_type: "text",
          title: "20%",
          payload: "20"
        }, {
          content_type: "text",
          title: "25%",
          payload: "25"
        }
      ]
    end
  end
end
