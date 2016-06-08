class OcrNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:receive]
  skip_before_action :authenticate_user!, only: [:receive]

  #
  # Get OCR's result from EC2
  #
  #
  #
  def receive
    @setting = Setting.all.first
    if @setting.present? && @setting.ocr
      OcrServices::ProcessPaystub.call(params)
    end
    render nothing: true, status: 200, content_type: 'text/html'
  end
end
