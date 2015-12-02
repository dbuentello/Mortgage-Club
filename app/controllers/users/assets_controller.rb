class Users::AssetsController < Users::BaseController
  def create
    Asset.bulk_update(current_user.borrower, asset_params[:assets])
    render json: {}
  end

  private

  def asset_params
    params.permit(assets: Asset::PERMITTED_ATTRS)
  end
end