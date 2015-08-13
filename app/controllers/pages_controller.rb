class PagesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :redirect_if_auth, only: [:index]

  def index
  end

  def take_home_test
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end
end
