class Users::PropertiesController < Users::BaseController
  before_action :set_loan, only: [:create]

  def create
    property_form = PropertyForm.new({
      loan: @loan,
      subject_property: @loan.subject_property,
      address: address,
      params: params
    })

    if property_form.save
      @loan.reload
      render json: {loan: LoanEditPage::LoanPresenter.new(@loan).show}
    else
      render json: {message: "cannot save property"}, status: 500
    end
  end

  def destroy
    property = Property.find_by_id(params[:id])
    if property.present?
      property.destroy
      render json: {message: "ok"}
    else
      render json: {message: "error"}
    end
  end

  def search
    # response = Zillow.search_property(params[:address], params[:citystatezip])
    response = ZillowService::GetPropertyInfo.call(params[:address], params[:citystatezip])

    if response
      render json: convert_property_type(response)
    else
      # render status: 404, nothing: true
      render json: {message: "cannot find"}
    end
  end

  private

  def convert_property_type(response)
    response["useCode"] = ZILLOW_PROPERTY_TYPE_MAPPING[response["useCode"]]
    response
  end

  def address
    @loan.subject_property.address || Address.new
  end
end
