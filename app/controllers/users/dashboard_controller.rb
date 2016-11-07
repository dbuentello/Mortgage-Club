class Users::DashboardController < Users::BaseController
  before_action :set_loan, only: [:show, :update_rate, :request_rate_lock]

  # show the loan dashboard if the status of loan is not 'new'.
  #
  # @return [HTML] Render borrower_app template (react view) with bootstrap data
  def show
    return redirect_to edit_loan_path(@loan) if @loan.new_loan?

    property = @loan.subject_property
    closing = @loan.closing || Closing.create(name: 'Closing', loan_id: @loan.id)
    loan_activities = @loan.loan_activities.includes(loan_member: :user).recent_loan_activities(10)

    bootstrap(
      loan: LoanDashboardPage::LoanPresenter.new(@loan).show,
      address: property.address.try(:address),
      manager: LoanDashboardPage::LoanMemberPresenter.new(@loan.relationship_manager).show,
      loan_activities: loan_activities,
      contact_list: LoanDashboardPage::LoanMemberAssociationsPresenter.new(@loan.loans_members_associations).show,
      checklists: LoanDashboardPage::ChecklistsPresenter.new(@loan.checklists).show,
      borrower_documents: LoanDashboardPage::DocumentsPresenter.new(@loan.borrower.documents.where(is_required: true)).show,
      closing_documents: LoanDashboardPage::DocumentsPresenter.new(closing.documents).show,
      property_documents: LoanDashboardPage::DocumentsPresenter.new(property.documents).show,
      loan_documents: LoanDashboardPage::DocumentsPresenter.new(@loan.documents).show,
      faqs_list: LoanDashboardPage::FaqsPresenter.new(Faq.all).show
    )

    respond_to do |format|
      format.html { render template: 'borrower_app' }
    end
  end

  def update_rate
    rate_programs = LoanTekServices::GetQuotes.new(@loan, false).call
    selected_rates = rate_programs.select { |rate| rate[:product] == @loan.amortization_type && rate[:interest_rate] == @loan.interest_rate }

    if selected_rates.any?
      if selected_rates.first[:discount_pts].round(5) != @loan.discount_pts
        RateServices::UpdateLoanDataFromSelectedRate.update_rate(@loan, selected_rates.first)
      end
      @loan.update(updated_rate_time: Time.zone.now)
      render json: {loan: LoanDashboardPage::LoanPresenter.new(@loan).show}
    else
      ShareRateMailer.update_rate_failed(@loan).deliver_now
      render json: {loan: LoanDashboardPage::LoanPresenter.new(@loan).show, error: "Sorry, something went wrong. Your mortgage advisor has been notified."}
    end
  end

  def request_rate_lock
    @loan.update(is_rate_locked: true)
    ShareRateMailer.request_rate_lock(@loan).deliver_now
    render json: {loan: LoanDashboardPage::LoanPresenter.new(@loan).show, alert: "Your mortgage advisor has been notified to lock in rate. You’ll receive a rate lock confirmation email shortly."}
  end
end
