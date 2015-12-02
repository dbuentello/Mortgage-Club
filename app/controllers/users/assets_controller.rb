class Users::AssetsController < Users::BaseController
  def create
    Asset.bulk_update(current_user.borrower, params[:assets])
    render json: {}
  end
end