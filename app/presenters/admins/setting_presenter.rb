class Admins::SettingPresenter
  def initialize(setting)
    @setting = setting
  end

  def show
    @setting.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :name, :value, :ocr]
    }
  end
end
