class PotentialRateDropUserController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :create

  def new
    respond_to do |format|
      format.html { render template: "public_app" }
    end
  end

  def create
  end
end
