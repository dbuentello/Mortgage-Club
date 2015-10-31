class EmploymentsController < ApplicationController
  def show
    employment = Employment.find(params[:id])

    render json: {employment: EmploymentPresenter.new(employment).show}
  end
end
