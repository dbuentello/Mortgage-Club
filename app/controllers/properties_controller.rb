class PropertiesController < ApplicationController
  def create
    set_loan_edit_page(params[:loan_id], params[:own_investment_property])

    credit_report_id = @loan.borrower.credit_report.try(:id)
    @properties = CreatePropertyForm.new({
      loan_id: params[:loan_id],
      credit_report_id: credit_report_id,
      subject_property: params[:subject_property],
      primary_property: params[:primary_property],
      rental_properties: params[:rental_properties]
    })

    if @properties.save
      render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show, liabilities: load_liabilities(@loan)}
    else
      render json: {message: "cannot save liabilities"}, status: 500
    end
  end

  def destroy
    property = Property.find_by_id(params[:id])
    if property.present?
      property.destroy
      render json: {message: 'ok'}
    else
      render json: {message: 'error'}
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

  def load_liabilities(loan)
    credit_report = loan.borrower.credit_report
    credit_report.liabilities
  end
end
