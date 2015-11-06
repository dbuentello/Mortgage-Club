class PagesController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!

  def index
    @refcode = params[:refcode]
    @mortgage_aprs = MortgageRateServices::GetMortgageApr.call
  end

  def take_home_test
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end
end
