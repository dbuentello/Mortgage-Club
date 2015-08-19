class Admins::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless current_user.admin?
      render status: :forbidden, text: "You don't have permmission to access this page!" and return
    end
  end
end
