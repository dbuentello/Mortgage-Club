module FacebookBotServices
  class GetInfoOfQuotes
    extend ParseQuotesForBot

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

      output.to_json
    end

    def self.generate_data(quotes, quote_query)
      return unless quotes.present?
      quotes = get_valid_quotes(quotes)
      return if quotes.empty?

      data = []
      host_name = ENV.fetch("HOST_NAME", "localhost:4000")

      ["30yearFixed", "15yearFixed", "5yearARM"].each do |type|
        programs = quotes.select { |p| p["ProductName"] == type }
        next if programs.empty?

        lowest_program = programs.first
        programs.each { |p| lowest_program = p if lowest_program["APR"] > p["APR"] }
        min_apr = format("%0.03f", calculate_apr(lowest_program))
        monthly_payment = number_to_currency(get_monthly_payment(lowest_program), precision: 0)
        admin_fee = get_admin_fee(lowest_program)
        total_closing_cost = number_to_currency(get_total_closing_cost(lowest_program, admin_fee), precision: 0)

        data << {
          title: "#{min_apr}% APR",
          subtitle: "Monthly Payment: #{monthly_payment}, Estimated Closing Cost: #{total_closing_cost}",
          url: Rails.application.routes.url_helpers.initial_quote_url(id: quote_query.code_id, program: type, host: host_name),
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
      when "30yearFixed"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/30_year_fixed.jpg"
      when "15yearFixed"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/15_year_fixed.jpg"
      when "5yearARM"
        img_url = "https://s3-us-west-2.amazonaws.com/production-homieo/facebook_messenger/5_1_ARM.jpg"
      end
      img_url
    end
  end
end
