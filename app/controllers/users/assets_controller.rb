class Users::AssetsController < Users::BaseController
  def create
    if Asset.bulk_update(current_user.borrower, asset_params[:assets])
      return render json: {message: 'Add new asset sucessfully'}, status: 200
    else
      return render json: {message: 'Add new asset failed'}, status: 500
    end
  end

  private

  def asset_params
    params.permit(assets: Asset::PERMITTED_ATTRS)
  end
end