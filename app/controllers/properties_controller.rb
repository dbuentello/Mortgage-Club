class PropertiesController < ApplicationController

  def create
    loan = Loan.find_by_id(params[:loan_id])
    loan.own_investment_property = params[:own_investment_property]
    loan.save
    credit_report_id = loan.borrower.credit_report.try(:id)

    @properties = CreatePropertyForm.new(params[:loan_id], params[:primary_property], params[:rental_properties], credit_report_id)

    if @properties.save
      render json: {loan: LoanPresenter.new(loan).edit, liabilities: load_liabilities(loan)}
    else
      render json: {message: "cannot save liabilities"}, status: 500
    end
  end

  def destroy
    Property.find_by_id(params[:id]).destroy
    render json: {message: "ok"}
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

  def load_liabilities(loan)
    credit_report = loan.borrower.credit_report
    credit_report.liabilities
  end
end
