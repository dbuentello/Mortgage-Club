class LoanActivitiesController < ApplicationController
  layout 'admin'

  skip_before_filter :authenticate_user!
  before_filter :redirect_if_auth

  def index
    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    render json: {message: 'okay'}
  end

end
