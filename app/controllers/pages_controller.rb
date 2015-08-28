class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def take_home_test
    respond_to do |format|
      format.html { render template: 'public_app' }
    end
  end
end
