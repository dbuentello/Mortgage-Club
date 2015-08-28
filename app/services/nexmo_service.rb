require 'nexmo'

class NexmoService
  def self.send_sms
    @client = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'] , secret: ENV['NEXMO_API_SECRET'])

    from = '19853020418'

    # to = '+84906944722'
    to = '16507877799'

    borrower = Borrower.first
    loan = borrower.user.loans.first
    text = "Dear #{borrower.user.to_s}, Your loan amount is #{loan.amount}. Interest rate is #{loan.interest_rate}."

    Rails.logger.info "Send from #{from} to #{to} with text: #{text}"

    @client.send_message(
      from: from,
      to: to,
      text: text
    )
  end
end