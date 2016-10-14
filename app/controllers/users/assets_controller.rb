class Users::AssetsController < Users::BaseController
  def create
    assets = asset_params[:assets]

    if assets.first[:institution_name].nil? && (assets.first[:current_balance].nil? || assets.first[:current_balance] == 0)
      return render json: {message: t("users.assets.create.success")}, status: 200
    end

    if Asset.bulk_update(current_user.borrower, assets)
      return render json: {message: t("users.assets.create.success")}, status: 200
    else
      return render json: {message: t("users.assets.create.failed")}, status: 500
    end
  end

  private

  def asset_params
    params.permit(assets: Asset::PERMITTED_ATTRS)
  end
end
