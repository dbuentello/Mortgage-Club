#
# Class Users::ElectronicSignatureController provides methods for borrower to signs into document
#
# @author Tang Nguyen <tang@mortgageclub.co>
#
class Users::ElectronicSignatureController < Users::BaseController
  before_action :set_loan, only: [:new, :create, :embedded_response]

  #
  # Show loading page to get document from Docusign
  #
  # @return [HTML] borrower app with bootstrap data includes loan and selected rate
  #
  def new
    RateServices::UpdateLoanDataFromSelectedRate.call(params[:id], params[:rate][:fees], rate_params, params[:rate][:thirty_fees])

    @loan.submitted!
    rental_properties = Property.where(is_primary: false, is_subject: false, loan: @loan)
    @loan.borrower.update(other_properties: JSON.dump(rental_properties.as_json(Property.json_options))) if rental_properties.present?

    # create the first loan activity
    activity = ActivityType.find_or_create_by(label: "Start processing", order_number: 1) do |f|
      f.activity_names << ActivityName.find_or_create_by(name: "Submitted loan to MortgageClub")
    end

    user = User.where(email: "billy@mortgageclub.co").last
    # add the first activity to loan
    LoanActivityServices::CreateActivity.new.call(user.loan_member, loan_activity_params(activity, @loan)) if user

    @loan.reload
    update_rate

    redirect_to "/my/dashboard/#{params[:id]}"

    # bootstrap(
    #   loan: LoanDashboardPage::LoanPresenter.new(@loan).show,
    #   rate: params[:rate]
    # )

    # respond_to do |format|
    #   format.html { render template: 'borrower_app' }
    # end
  end

  #
  # Update loan data from selected rate, call Docusign to get document for borrower signs into
  #
  # @return [HTML] document view
  #
  def create
    return render nothing: true, status: 200 if Rails.env.test?
    RateServices::UpdateLoanDataFromSelectedRate.call(params[:id], params[:fees], lender_params, params[:thirty_fees])
    @loan.reload

    envelope = Docusign::CreateEnvelopeService.new.call(current_user, @loan)
    recipient_view = DocusignRest::Client.new.get_recipient_view(
      envelope_id: envelope['envelopeId'],
      name: "#{current_user.first_name} #{current_user.last_name}",
      email: current_user.email,
      return_url: embedded_response_electronic_signature_index_url(
        loan_id: params[:id],
        envelope_id: envelope['envelopeId'],
        user_id: current_user.id
      )
    )

    if recipient_view
      render json: {message: recipient_view}, status: 200
    else
      render json: {message: t("errors.iframe_render_error")}, status: 500
    end
  end

  # GET /electronic_signature/embedded_response
  #
  # Callback Docusign will be called after borrower signs completely.
  #
  # @return [HTML] loans dashboard of borrower
  # If loan has co-borrower, this function return a document view for co-borrower signs into
  def embedded_response
    utility = DocusignRest::Utility.new

    if params[:event] == "signing_complete"
      if @loan.secondary_borrower && @loan.secondary_borrower.user.id != params[:user_id]
        recipient_view = DocusignRest::Client.new.get_recipient_view(
          envelope_id: params[:envelope_id],
          name: "#{@loan.secondary_borrower.user.first_name} #{@loan.secondary_borrower.user.last_name}",
          email: @loan.secondary_borrower.user.email,
          return_url: embedded_response_electronic_signature_index_url(
            loan_id: params[:loan_id],
            envelope_id: params[:envelope_id],
            user_id: @loan.secondary_borrower.user.id
          )
        )

        return redirect_to recipient_view["url"] if recipient_view
      end

      @loan.submitted!
      rental_properties = Property.where(is_primary: false, is_subject: false, loan: @loan)
      @loan.borrower.update(other_properties: JSON.dump(rental_properties.as_json(Property.json_options))) if rental_properties.present?

      # TODO: why call two services below:
      Docusign::MapEnvelopeToLenderDocument.new(params[:envelope_id], params[:user_id], params[:loan_id]).delay.call
      RatesComparisonServices::Base.new(params[:loan_id], params[:user_id]).call
      render text: utility.breakout_path("/my/dashboard/#{params[:loan_id]}"), content_type: 'text/html'
    elsif params[:event] == "ttl_expired"
      # the session has been expired
    else
      render text: utility.breakout_path("/my/dashboard/#{params[:loan_id]}"), content_type: 'text/html'
    end
  end

  private

  def lender_params
    params.require(:lender).permit(
      :interest_rate, :lender_name, :lender_nmls_id,
      :period, :amortization_type, :monthly_payment,
      :lender_credits, :apr,
      :loan_type, :total_closing_cost,
      :amount, :cash_out,
      :discount_pts
    )
  end

  def rate_params
    params.require(:rate).permit(
      :interest_rate, :lender_name, :nmls,
      :period, :product, :monthly_payment,
      :lender_credits, :apr,
      :loan_type, :total_closing_cost,
      :loan_amount, :cash_out,
      :discount_pts
    )
  end

  def loan_activity_params(activity, loan)
    loan_activity_params = {}
    loan_activity_params[:activity_type_id] = activity.id
    loan_activity_params[:activity_status] = 0
    loan_activity_params[:name] = activity.activity_names.first.name
    loan_activity_params[:user_visible] = true
    loan_activity_params[:loan_id] = loan.id
    loan_activity_params[:start_date] = Time.zone.now
    loan_activity_params
  end

  def update_rate
    rate_programs = LoanTekServices::GetQuotes.new(@loan, false).call
    selected_rates = rate_programs.select { |rate| rate[:product] == @loan.amortization_type && rate[:interest_rate] == @loan.interest_rate }

    if selected_rates.any?
      if selected_rates.first[:discount_pts].round(5) != @loan.discount_pts
        RateServices::UpdateLoanDataFromSelectedRate.update_rate(@loan, selected_rates.first)
      end
    end

    @loan.update(updated_rate_time: Time.zone.now)
  end
end
