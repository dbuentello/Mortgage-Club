class ShareRateMailer < ActionMailer::Base
  def email_me(params, current_user)
    @first_name = params[:first_name]
    @rate = params[:rate]
    @code = params[:code_id]

    quote = QuoteQuery.find_by_code_id(params[:code_id])
    @quote_query = JSON.load quote.query
    @current_user = current_user

    email_from = (current_user && current_user.has_role?(:loan_member)) ? current_user.email : "billy@mortgageclub.co"

    mail(
      from: email_from,
      to: params[:email],
      subject: "Your rate quote from MortgageClub"
    )
  end
end
