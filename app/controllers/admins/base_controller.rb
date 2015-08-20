class Admins::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless current_user.admin?
      redirect_to admin_root_url, alert: "The page does not exist or you don't have permmission to access!"
    end
  end
end
