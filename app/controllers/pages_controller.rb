class PagesController < ApplicationController
  before_filter :redirect_if_auth, only: [:index]
  layout 'public'

  def index
    bootstrap
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end

  def take_home_test
    bootstrap
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end
end
