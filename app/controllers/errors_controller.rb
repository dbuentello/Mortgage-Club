class ErrorsController < ApplicationController
  def show
    status_code = params[:code] || 500
    @back_to_home_path = find_root_path
    render status_code.to_s, status: status_code
  end
end