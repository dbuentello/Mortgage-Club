class CalculateLoanAmountService
  def self.call(loan)
    if loan.refinance?
      amount = calculate_loan_amount_for_refinance_loan(loan)
    elsif loan.purchase?
      amount = calculate_loan_amount_for_purchase_loan(loan)
    end
    amount
  end

  def self.calculate_loan_amount_for_refinance_loan(loan)
    if loan.subject_property.mortgage_payment_liability
      amount = loan.subject_property.mortgage_payment_liability.balance
    else
      amount = loan.subject_property.market_price.to_f * 0.75
    end
    amount
  end

  def self.calculate_loan_amount_for_purchase_loan(loan)
    if loan.down_payment
      amount = loan.subject_property.purchase_price.to_f - loan.down_payment
    else
      amount = loan.subject_property.purchase_price.to_f * 0.75
    end
    amount
  end
end
