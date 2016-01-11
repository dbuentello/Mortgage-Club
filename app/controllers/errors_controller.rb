class ErrorsController < ApplicationController
  def show
    status_code = params[:code] || 500
    flash.alert = "Status #{status_code}"
    @back_to_home_path = find_root_path
    render status_code.to_s, status: status_code
  end

  private

  def find_root_path
    return unauthenticated_root_path unless current_user
    return admin_root_path if current_user.has_role?(:admin)
    return loan_member_root_path if current_user.has_role?(:lender_member)
    return borrower_root_path
  end
end