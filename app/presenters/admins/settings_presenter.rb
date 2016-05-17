class Admins::SettingsPresenter
  def initialize(settings)
    @settings = settings
  end

  def show
    @settings.as_json(json_options)
  end

  private

  def json_options
    {
      only: [:id, :name, :value, :ocr]
    }
  end
end
