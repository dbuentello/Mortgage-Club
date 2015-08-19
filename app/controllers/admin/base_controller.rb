class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless current_user.admin?
      render status: :forbidden, text: "Bạn không có quyền truy cập trang này!" and return
    end
  end
end
