class Users::BaseController < ApplicationController
  if Rails.env.production?
    skip_before_action :authenticate_user!
    before_action :fake_authenticate!
  else
    before_action :authenticate_borrower!
  end

  private

  def fake_authenticate!
    @current_user = User.where(email: 'borrower@gmail.com').last
    sign_in(@current_user)
    unless @current_user.borrower?
      redirect_to borrower_root_url, alert: "The page does not exist or you don't have permmission to access!"
    end
  end

  def authenticate_borrower!
    unless current_user.borrower?
      redirect_to borrower_root_url, alert: "The page does not exist or you don't have permmission to access!"
    end
  end
end