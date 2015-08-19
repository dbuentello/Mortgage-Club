class Users::BaseController < ApplicationController
  before_action :authenticate_borrower!

  private

  def authenticate_borrower!
    unless current_user.borrower?
      render status: :forbidden, text: "You don't have permmission to access this page!" and return
    end
  end
end