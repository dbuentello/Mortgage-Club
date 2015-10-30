class EmploymentsController < ApplicationController
  def show
    employment = Employment.find(params[:id])

    # demo, it will be removed when we get ABBYY's license
    employment.update(
      employer_name: 'Samsung',
      pay_frequency: 'weekly',
      current_salary: 2334
    )
    employment.address.update(full_text: '227 Nguyen Van Cu, Q5, TP.HCM')

    render json: {employment: EmploymentPresenter.new(employment).show}
  end
end
