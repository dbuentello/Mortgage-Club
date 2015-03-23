class LoanPropertyController < ApplicationController
  
  def show
    @loan_property = Loan.find(params[:loan_id]).property
  end

  def create
    @loan_property = Loan.find(params[:loan_id]).create_property(loan_property_params)
  end

  def update
    @loan_property = Loan.find(params[:loan_id]).property
    if @loan_property.update(loan_property_params)
      @loan_property
    else
      render json: {:message => 'Unable to update'}, status: 500
    end
  end

  private

    def loan_property_params
      params.require(:record).permit(Property::PERMITTED_ATTRS)
    end
end
