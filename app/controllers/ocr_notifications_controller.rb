class OcrNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:receive]
  skip_before_action :authenticate_user!, :only => [:receive]

  include HTTParty

  def receive
    if request.raw_post.present?
      raw_post = JSON.parse(request.raw_post)

      if raw_post["SubscribeURL"].present?
        ConfirmSubscriptionService.call(raw_post)
      else
        OcrServices::ProcessPaystub.call(raw_post)
      end
    end
    render nothing: true, status: 200, content_type: 'text/html'
  end
end