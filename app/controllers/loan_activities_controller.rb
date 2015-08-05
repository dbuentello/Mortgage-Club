class LoanActivitiesController < ApplicationController
  layout 'admin'

  def index
    @loan = loan

    bootstrap

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    render json: {message: 'okay'}
  end

  private

  def loan
    # WILLDO: Get loan list which staff handles
    @loan ||= Loan.first
  end

end
