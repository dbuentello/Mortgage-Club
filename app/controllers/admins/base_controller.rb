class Admins::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless current_user.admin?
      redirect_to admin_root_url, alert: t("messages.errors.page_not_found_or_permission_denied")
    end
  end
end
