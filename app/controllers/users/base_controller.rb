class Users::BaseController < ApplicationController
  before_action :authenticate_borrower!

  private

  def authenticate_borrower!
    unless current_user.borrower?
      redirect_to borrower_root_url, alert: t("messages.info.page_not_found_or_permission_denied")
    end
  end
end