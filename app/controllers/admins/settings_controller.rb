class Admins::SettingsController < Admins::BaseController
  before_action :set_setting, except: [:index]

  def index
    enable_ocr = Admins::SettingPresenter.new(Setting.first).show
    settings = Admins::SettingsPresenter.new(Setting.where.not(id: Setting.first.id)).show

    bootstrap(
      enable_ocr: enable_ocr,
      settings: settings
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    bootstrap(
      setting: Admins::SettingPresenter.new(@setting).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @setting.update(setting_params)
      render json: {
        setting: @setting,
        message: t("info.success", status: t("common.status.updated"))
      }, status: 200
    else
      render json: {message: @setting.errors.full_messages.first}, status: 500
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:name, :value, :ocr)
  end

  def set_setting
    @setting = Setting.find(params[:id])
  end
end
