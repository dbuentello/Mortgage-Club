class PagesController < ApplicationController
  before_filter :redirect_if_auth, only: [:index]

  def index
    bootstrap
    respond_to do |format|
      format.html { render template: 'pages/app' }
    end
  end

private
  def redirect_logged_in_user
    redirect
  end
end
