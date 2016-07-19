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

  def self.update_graph_quotes_email
    QuoteQuery.where(alert: true).each do |q|
      new_graph = self.update_graph_quote(q)
      self.send_email_to_users(q.id, new_graph) if new_graph.present?
    end
  end

  def self.send_email_to_users(quote_id, new_graph)
    RateAlertQuoteQuery.where(quote_query_id: quote_id).each do |r|
      @pre_graph = GraphQuoteQuery.where("quote_query_id = ? AND DATE(created_at) = ?", quote_id, r.created_at.to_date).first
      RateAlertQuoteMailer.inform_quote_changed(r, new_graph).deliver_later if @pre_graph.present? && check_updating(new_graph, @pre_graph)
    end
  end

  def self.update_graph_quote(quote)
    new_graph = nil
    @quote = quote
    @query = JSON.parse(@quote.query)
    @quotes = LoanTekServices::GetInitialQuotes.new(@query).lowest_apr
    if @quotes
      year30 = @quotes["30 year fixed"].to_json
      year15 = @quotes["15 year fixed"].to_json
      arm71 = @quotes["7/1 ARM"].to_json
      arm51 = @quotes["5/1 ARM"].to_json
      new_graph = GraphQuoteQuery.new(year30: year30, year15: year15, arm71: arm71, arm51: arm51, quote_query_id: @quote.id)
      new_graph.save!
    end
    new_graph
  end

  def self.check_updating(new_quotes, pre_quotes)
    return true if check_updating_program(JSON.parse(new_quotes.year30), JSON.parse(pre_quotes.year30))
    return true if check_updating_program(JSON.parse(new_quotes.year15), JSON.parse(pre_quotes.year15))
    return true if check_updating_program(JSON.parse(new_quotes.arm71), JSON.parse(pre_quotes.arm71))
    return true if check_updating_program(JSON.parse(new_quotes.arm51), JSON.parse(pre_quotes.arm51))
    false
  end

  def self.check_updating_program(new_program, pre_program)
    rate = new_program["interest_rate"] == pre_program["interest_rate"]
    lender_credits = new_program["lender_credits"] == pre_program["lender_credits"]
    return true if !rate || !lender_credits
    false
  end
end
