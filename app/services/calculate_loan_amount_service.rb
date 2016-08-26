#
# Class CalculateLoanAmountService provides methods to calculate loan amount
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
class CalculateLoanAmountService
  def self.call(loan)
    if loan.refinance?
      amount = calculate_loan_amount_for_refinance_loan(loan)
    elsif loan.purchase?
      amount = calculate_loan_amount_for_purchase_loan(loan)
    end
    amount
  end

  #
  # Calculate loan amount for refinance loan
  #
  # @param [Object] loan: ActiveRecord
  #
  # @return [Float] loan amount
  #
  def self.calculate_loan_amount_for_refinance_loan(loan)
    if loan.subject_property.estimated_mortgage_balance
      amount = loan.subject_property.estimated_mortgage_balance
    else
      amount = 0
    end
    amount
  end

  #
  # Calculate loan amount for purchase loan
  #
  # @param [Object] loan: ActiveRecord
  #
  # @return [Float] loan amount
  #
  def self.calculate_loan_amount_for_purchase_loan(loan)
    if loan.down_payment
      amount = loan.subject_property.purchase_price.to_f - loan.down_payment
    else
      amount = 0
    end
    amount
  end
end
