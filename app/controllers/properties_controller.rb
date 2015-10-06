class PropertiesController < ApplicationController

  def create
    loan = Loan.find_by_id(params[:loan_id])
    loan.own_investment_property = params[:own_investment_property]
    loan.save
    @properties = CreatePropertyForm.new(params[:loan_id], params[:primary_property], params[:rental_properties])

    if @properties.save
      render json: {loan: LoanPresenter.new(loan).edit}
    else
      render json: {message: 'error'}
    end
  end

  def destroy
    Property.find_by_id(params[:id]).destroy
    render json: {message: 'ok'}
  end

  def search
    response = ZillowService::GetPropertyInfo.call(params[:address], params[:citystatezip])

    if response
      render json: convert_property_type(response)
    else
      render json: {message: 'cannot find'}
    end
  end

  private

  def convert_property_type(response)
    response['useCode'] = ZILLOW_PROPERTY_TYPE_MAPPING[response['useCode']]
    response
  end
end
