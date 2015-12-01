class Users::AssetsController < Users::BaseController
  def create
    Asset.bulk_update(params[:borrower_id], params[:assets])
    render json: {}
  end
end