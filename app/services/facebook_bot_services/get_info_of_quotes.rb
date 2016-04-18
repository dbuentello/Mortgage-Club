module FacebookBotServices
  class GetInfoOfQuotes
    extend ParseQuotesForBot

    PRODUCT = {
      "30yearFixed" => "30 year fixed",
      "15yearFixed" => "15 year fixed",
      "5yearARM" => "5/1 ARM"
    }

    def self.call(params)
      output = "We're sorry, there aren't any quotes matching your needs."
      service = LoanTekServices::GetQuotesForFacebookBot.new(params)

      if service.call
        quote_query = QuoteQuery.new(query: service.query_content)

        if quote_query.save
          output = generate_output(service.quotes, quote_query)
        end
      end

      output
    end

    def self.generate_output(quotes, quote_query)
      return if quotes.nil?
      quotes = get_valid_quotes(quotes)
      return if quotes.empty?

      output = []
      host_name = ENV.fetch("HOST_NAME", "localhost:4000")

      ["30yearFixed", "15yearFixed", "5yearARM"].each do |type|
        programs = quotes.select { |p| p["ProductName"] == type }
        next if programs.empty?

        lowest_program = programs.first
        programs.each { |p| lowest_program = p if lowest_program["APR"] > p["APR"] }
        min_apr = format("%0.03f", calculate_apr(lowest_program))
        monthly_payment = number_to_currency(get_monthly_payment(lowest_program), precision: 0)
        total_closing_cost = number_to_currency(get_total_closing_cost(lowest_program), precision: 0)

        output << {
          title: "#{min_apr}% APR",
          subtitle: "Monthly Payment: #{monthly_payment}, Estimated Closing Cost: #{total_closing_cost}",
          url: Rails.application.routes.url_helpers.initial_quote_url(id: quote_query.code_id, program: type, host: host_name),
          type: type
        }
      end

      output
    end
  end
end
