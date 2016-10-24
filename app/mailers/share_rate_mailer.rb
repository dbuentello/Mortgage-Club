class ShareRateMailer < ActionMailer::Base
  def email_me(params, current_user)
    @first_name = params[:first_name]
    @rate = params[:rate]
    @code = params[:code_id]

    quote = QuoteQuery.find_by_code_id(params[:code_id])
    @quote_query = JSON.load quote.query
    @current_user = current_user

    if current_user && current_user.has_role?(:loan_member)
      @email_from = current_user.loan_member.email.present? ? current_user.loan_member.email : "billy@mortgageclub.co"
      @phone = current_user.loan_member.phone_number.present? ? current_user.loan_member.phone_number : "650-787-7799"
    else
      @email_from = "billy@mortgageclub.co"
      @phone = "650-787-7799"
    end


    mail(
      from: @email_from,
      to: params[:email],
      subject: "Your rate quote from MortgageClub"
    )
  end
end
