class Users::BaseController < ApplicationController
  before_action :authenticate_borrower!

  private

  def authenticate_borrower!
    unless current_user.borrower?
      redirect_to borrower_root_url, alert: "The page does not exist or you don't have permmission to access!"
    end
  end
end
