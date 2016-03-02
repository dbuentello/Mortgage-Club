class OcrNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:receive]
  skip_before_action :authenticate_user!, :only => [:receive]

  def receive
    @setting = Setting.all.first
    if @setting.present? && @setting.ocr
      OcrServices::ProcessPaystub.call(params)
    end
    render nothing: true, status: 200, content_type: 'text/html'
  end
end
