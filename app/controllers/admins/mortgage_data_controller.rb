class Admins::MortgageDataController < Admins::BaseController
  def index
    mortgage_data = MortgageData.paginate(page: params[:page]).order("created_at DESC")
    mortgage_data_count = (1.0 * MortgageData.count / MortgageData.per_page).ceil

    if params[:search]
      mortgage_data_all = MortgageData.search(search_params[:search])
      mortgage_data = mortgage_data_all.paginate(page: params[:page]).order("created_at DESC")
      mortgage_data_count = (1.0 * mortgage_data_all.count / MortgageData.per_page).ceil
    end

    bootstrap(mortgage_data: mortgage_data,
              mortgage_data_count: mortgage_data_count,
              current_page: (params[:page] || 1)
             )

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
