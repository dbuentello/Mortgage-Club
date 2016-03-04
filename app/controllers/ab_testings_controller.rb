class AbTestingsController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def refinancing_alert
    @refcode = params[:refcode]
    @mortgage_aprs = HomepageRateServices::GetMortgageAprs.call
    @last_updated = nil
    if @mortgage_aprs['updated_at'].present?
      @last_updated = Time.zone.parse(@mortgage_aprs['updated_at'].to_s).strftime('%b %d, %G %I:%M %p %Z')
      @last_updated = @last_updated.gsub("PDT", "PST")
    end

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

end
