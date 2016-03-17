class Admins::SettingsController < Admins::BaseController
  before_action :set_setting, except: [:index]

  def index
    @setting = Setting.all.first

    bootstrap(
      setting: @setting
    )
    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    if @setting.update(setting_params)
      render json: {
        setting: @setting,
        message: t("info.success", status: "common.status.updated"))
      }, status: 200
    else
      render json: {message: @setting.errors.full_messages.first}, status: 500
    end
  end

  private

  def setting_params
    params.permit(:id, :ocr)
  end

  def set_setting
    @setting = Setting.find(params[:id])
  end
end
