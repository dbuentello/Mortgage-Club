module BotServices
  class CalculateDtiRatio
    attr_reader :annual_income, :credit_card_payments, :car_loan_payments, :other_loan_obligations, :sender_id

    def initialize(sender_id, params)
      @annual_income = params[:annual_income].to_i
      @credit_card_payments = params[:car_loan_payments].to_i
      @car_loan_payments = params[:credit_card_payments].to_i
      @other_loan_obligations = params[:other_loan_obligations].to_i
      @sender_id = sender_id
    end

    def call
      total_monthly_debts = credit_card_payments + car_loan_payments + other_loan_obligations
      remainning = annual_income / 12 - total_monthly_debts
      max_estimated_mortgage_payment = (remainning - total_monthly_debts) * 43 / 100

      ap total_monthly_debts
      ap remainning
      ap max_estimated_mortgage_payment

      url = "http://chart.apis.google.com/chart?chd=s:9aP&cht=p&chts=000000,24&chs=600x300&chdl=Remainning|Total+Monthly+Debts|Max+estimated+mortgage+payment&chtt=Estimated+home+loan+eligibility&chco=DDDDDD|FD8602|55A2FF&chxr=0,#{remainning},#{total_monthly_debts},#{max_estimated_mortgage_payment}"

      BotServices::FacebookService.send_message(sender_id, BotServices::FacebookService.image_message(url))
    end
  end
end
