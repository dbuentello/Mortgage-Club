class ShareRateMailer < ActionMailer::Base
  def email_me(params, current_user)
    if params[:body]
      if params[:body].include? "[first_name]"
        body = params[:body].gsub! "[first_name]", params[:first_name]
      else
        body = params[:body]
      end

      mail(
        from: "#{current_user} <#{current_user.email}>",
        to: params[:email],
        subject: params[:subject],
        body: body,
        content_type: "text/html"
      )
    else
      @first_name = params[:first_name]
      @rate = params[:rate]
      @code = params[:code_id]

      quote = QuoteQuery.find_by_code_id(params[:code_id])
      @quote_query = JSON.load quote.query
      @current_user = current_user

      if current_user && current_user.has_role?(:loan_member)
        @email_from = current_user.email.present? ? "#{current_user} <#{current_user.email}>" : "Billy Tran <billy@mortgageclub.co>"
        @email = current_user.email.present? ? current_user.email : "billy@mortgageclub.co"
        @phone = current_user.loan_member.phone_number.present? ? current_user.loan_member.phone_number : "(650) 787-7799"
      else
        @email_from = "Billy Tran <billy@mortgageclub.co>"
        @email = "billy@mortgageclub.co"
        @phone = "(650) 787-7799"
      end

      mail(
        from: @email_from,
        to: params[:email],
        subject: "Your rate quote from MortgageClub"
      )
    end
  end
end
