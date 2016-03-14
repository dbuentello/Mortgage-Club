class Users::AssetsController < Users::BaseController
  def create
    if Asset.bulk_update(current_user.borrower, asset_params[:assets])
      return render json: {message: t("users.assets.create.add_success")}, status: 200
    else
      return render json: {message: t("users.assets.create.add_failed")}, status: 500
    end
  end

  private

  def asset_params
    params.permit(assets: Asset::PERMITTED_ATTRS)
  end
end
