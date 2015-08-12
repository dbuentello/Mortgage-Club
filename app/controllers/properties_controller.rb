class PropertiesController < ApplicationController
  def search
    response = Zillow.search_property(params[:address], params[:citystatezip])
    if response
      render json: response
    else
      # render status: 404, nothing: true
      render json: {message: 'cannot find'}
    end
  end
end
