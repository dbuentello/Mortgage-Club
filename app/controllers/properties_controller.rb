class PropertiesController < ApplicationController
  def search
    # response = Zillow.search_property(params[:address], params[:citystatezip])
    response = ZillowService::GetPropertyInfo.call(params[:address], params[:citystatezip])

    if response
      render json: convert_property_type(response)
    else
      # render status: 404, nothing: true
      render json: {message: 'cannot find'}
    end
  end

  private

  def convert_property_type(response)
    response['useCode'] = ZILLOW_PROPERTY_TYPE_MAPPING[response['useCode']]
    response
  end
end
