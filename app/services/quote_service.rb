class QuoteService

    def self.create_graph_quote(quote)
      @quote = quote
      @query = {}
      @query = JSON.parse(@quote.query) if @quote
      @quotes = LoanTekServices::GetInitialQuotes.new(@query).lowest_apr
      if @quotes
        year30 = @quotes["30 year fixed"].to_json
        year15 = @quotes["15 year fixed"].to_json
        arm71 = @quotes["7/1 ARM"].to_json
        arm51 = @quotes["5/1 ARM"].to_json
        graph = GraphQuoteQuery.new(year30: year30, year15: year15, arm71: arm71, arm51: arm51, quote_query_id: quote.id)
        graph.save!
      end

    end

end
