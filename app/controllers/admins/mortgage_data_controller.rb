class Admins::MortgageDataController < Admins::BaseController
  def index
    mortgage_data = MortgageData.all
    mortgage_data = MortgageData.search(search_params[:search]).order("created_at DESC") if params[:search]
    bootstrap(mortgage_data: mortgage_data)

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def show
    bootstrap(mortgage_data_record: mortgage_data_record)
    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  private

  def search_params
    params.require(:search).permit(:search)
  end

  def mortgage_data_record
    MortgageData.find(params[:id])
  end

  def mortgage_data_params
    params.require(:mortage_data).permit(MortgageData::PERMITTED_ATTRS)
  end
end
