# get quotes for Facebook Bot
require "quotes_formulas"

module FacebookBotServices
  class GetInfoOfQuotes
    extend ActionView::Helpers::NumberHelper
    extend QuotesFormulas

    PRODUCT = {
      "30yearFixed" => "30 year fixed",
      "15yearFixed" => "15 year fixed",
      "5yearARM" => "5/1 ARM"
    }

    def self.call(params)
      output = default_output
      service = LoanTekServices::GetQuotesForFacebookBot.new(params)

      if service.call
        quote_query = QuoteQuery.new(query: service.query_content)

        if quote_query.save
          output[:data] = generate_data(service.quotes, quote_query)
          output[:status_code] = 200
        end
      end
      output
    end

    def self.generate_data(quotes, quote_query)
      return if quotes.empty?

      data = []
      host_name = ENV.fetch("HOST_NAME", "localhost:4000")

      ["30 year fixed", "15 year fixed", "5/1 ARM", "7/1 ARM"].each do |type|
        programs = quotes.select { |p| p[:product] == type && p[:lender_credits] <= 1000 }
        next if programs.empty?

        lowest_program = programs.first
        programs.each { |p| lowest_program = p if lowest_program[:interest_rate] > p[:interest_rate] }
        min_rate = format("%0.03f", lowest_program[:interest_rate] * 100)
        monthly_payment = number_to_currency(lowest_program[:monthly_payment], precision: 0)
        estimated_closing_costs = number_to_currency(lowest_program[:total_closing_cost], precision: 0)
        lender_credit = number_to_currency(lowest_program[:lender_credits], precision: 0)

        data << {
          title: "#{min_rate}%",
          subtitle: "Monthly Payment: #{monthly_payment}, Discount Points: #{lender_credit}, Estimated Closing Costs: #{estimated_closing_costs}",
          url: Rails.application.routes.url_helpers.initial_quote_url(id: quote_query.code_id, host: host_name),
          type: type,
          img_url: get_img_url(type)
        }
      end

      data
    end

    def self.default_output
      {
        data: "Sorry, I can't find any mortgage loans for you. I've asked my human colleagues to look into it. To go back to the main menu, simply type" + ' "start over"!',
        status_code: 404
      }
    end

    def self.get_img_url(type)
      img_url = ""
      case type
      when "30 year fixed"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/30_year_fixed.jpg"
      when "15 year fixed"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/15_year_fixed.jpg"
      when "5/1 ARM"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/5_1_ARM.jpg"
      when "7/1 ARM"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/5_1_ARM.jpg"
      end
      img_url
    end
  end
end
