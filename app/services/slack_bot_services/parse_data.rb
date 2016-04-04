module ParseData
  def parsed_data(params)
    return unless data = params["result"]
    return unless context = data["contexts"].last
    return unless parameters = context["parameters"]

    {
      purpose: parameters["purpose"],
      zipcode: parameters["zipcode"],
      property_value: parameters["property_value"],
      down_payment: parameters["purpose"] == "purchase" ? parameters["down_payment"] : nil,
      mortgage_balance: parameters["purpose"] == "refinance" ? parameters["mortgage_balance"] : nil,
      usage: parameters["usage"],
      property_type: parameters["property_type"],
      credit_score: parameters["credit_score"],
      name: parameters["name"],
      email: parameters["email"].split(" ").last
    }
  end
end
