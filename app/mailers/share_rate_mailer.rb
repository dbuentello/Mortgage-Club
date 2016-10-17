class ShareRateMailer < ActionMailer::Base
  default from: ENV["EMAIL_SENDER"]
  def email_me(params)
    @first_name = params[:first_name]
    @rate = params[:rate]
    @code = params[:code_id]

    quote = QuoteQuery.find_by_code_id(params[:code_id])
    @quote_query = JSON.load quote.query

    mail(
      to: params[:email],
      subject: "Your rate quote from MortgageClub"
    )
  end
end
