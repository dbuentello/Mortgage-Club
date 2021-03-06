class AbTestingsController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :homepage_data, only: [:refinance_alert]

  # alert to new user about the loan. Helping new user see about good rates and attract user.
  # Beside that, get user email to maketing
  #
  # @return [object] info of homepage and rate table.
  def refinance_alert
    bootstrap(
      last_updated: @last_updated,
      refcode: @refcode,
      mortgage_aprs: @mortgage_aprs,
      homepage: {
        title_alert: I18n.t('homepage.title_alert'),
        btn_alert: I18n.t('homepage.btn_alert'),
        description_alert: I18n.t('homepage.description_alert')
      }
    )
    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  private

  # TODO: duplicate - pages controller index
  def homepage_data
    @refcode = params[:refcode]
    @mortgage_aprs = HomepageRateServices::GetMortgageAprs.call
    @last_updated = nil
    if @mortgage_aprs['updated_at'].present?
      @last_updated = Time.zone.parse(@mortgage_aprs['updated_at'].to_s).strftime('%b %d, %G %I:%M %p %Z')
      @last_updated = @last_updated.gsub("PDT", "PST")
    end
  end
end
