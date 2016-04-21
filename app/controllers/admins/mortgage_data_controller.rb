class Admins::MortgageDataController < Admins::BaseController
  def index
    bootstrap(mortgage_data: MortgageData.all)

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def search
  end

  private

  def search_params
    params.require(:search).permit(:address)
  end

end
