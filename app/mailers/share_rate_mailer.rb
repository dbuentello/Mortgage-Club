class ShareRateMailer < ActionMailer::Base
  def email_me(params, current_user)
    if params[:body].present?
      body = params[:body]

      if params[:body].include? "[first_name]"
        body = params[:body].gsub! "[first_name]", params[:first_name]
      end

      if params[:body].include? "[property_address]"
        body = params[:body].gsub! "[property_address]", params[:property_address]
      end

      mail(
        from: "#{current_user} <#{current_user.email}>",
        to: params[:email],
        subject: params[:subject],
        body: body,
        bcc: current_user.email,
        content_type: "text/html"
      )
    else
      @first_name = params[:first_name]
      @rate = params[:rate]
      @quote_url = "https://www.mortgageclub.co/quotes/#{params[:code_id]}"

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
        bcc: @email_from,
        subject: "Your rate quote from MortgageClub"
      )
    end
  end

  def update_rate_failed(loan)
    mortgage_advisor_title = LoanMembersTitle.find_by_title("Mortgage Advisor")
    mortgage_advisor = LoanMember.joins(:loans_members_associations).where(loans_members_associations: {loan_id: loan.id, loan_members_title_id: mortgage_advisor_title.id}).first

    @borrower_full_name = loan.borrower.user.to_s
    @loan_member_first_name = mortgage_advisor.user.first_name
    @property_address = loan.subject_property.address.address

    mail(
      from: "Billy Tran <billy@mortgageclub.co>",
      to: mortgage_advisor.user.email,
      subject: "[ACTION NEEDED] Update rate for #{@borrower_full_name} - #{@property_address}"
    )
  end

  def request_rate_lock(loan)
    mortgage_advisor_title = LoanMembersTitle.find_by_title("Mortgage Advisor")
    mortgage_advisor = LoanMember.joins(:loans_members_associations).where(loans_members_associations: {loan_id: loan.id, loan_members_title_id: mortgage_advisor_title.id}).first

    @borrower_full_name = loan.borrower.user.to_s
    @loan_member_first_name = mortgage_advisor.user.first_name
    @property_address = loan.subject_property.address.address

    mail(
      from: "Billy Tran <billy@mortgageclub.co>",
      to: mortgage_advisor.user.email,
      subject: "[ACTION NEEDED] Lock in rate for #{@borrower_full_name} - #{@property_address}"
    )
  end
end
