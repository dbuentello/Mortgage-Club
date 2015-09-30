class PropertiesController < ApplicationController

  def create
    loan = Loan.find_by_id(params[:loan_id])
    loan.own_investment_property = params[:own_investment_property]
    loan.save
    @properties = CreatePropertyForm.new(params[:loan_id], params[:primary_property], params[:rental_properties])

    if @properties.save
      render json: {message: 'ok'}
    else
      render json: {message: 'not ok'}
    end
  end

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
