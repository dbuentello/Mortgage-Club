class AbTestingsController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def refinancing_alert
    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

end
