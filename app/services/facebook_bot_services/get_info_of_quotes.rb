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
      service = LoanTekServices::GetQuotesForBot.new(params)

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
        lender_credit = number_to_currency(calculate_lender_credit(lowest_program), precision: 0)
        fees = "$0 origination fee"

        output << {
          title: PRODUCT[type],
          subtitle: "#{min_apr}% rate, #{fees}, #{lender_credit} lender credit",
          url: Rails.application.routes.url_helpers.initial_quote_url(id: quote_query.code_id, program: type, host: host_name)
        }
      end

      output
    end
  end
end
