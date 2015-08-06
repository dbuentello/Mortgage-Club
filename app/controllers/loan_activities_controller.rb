class LoanActivitiesController < ApplicationController
  layout 'admin'

  def index
    @loan = loan
    loan_activity_list = LoanActivity::LIST

    bootstrap(
      loan: @loan,
      activity_list: loan_activity_list,
      first_activity: LoanActivity.where(name: LoanActivity::LIST.values[0][0], loan_id: @loan.id).first
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    render json: {message: 'okay'}
  end

  def create
    result = LoanActivityServices::CreateActivity.new.call(loan_member, loan_activity_params)

    if result.success?
      render json: {success: "Success"}, status: 200
    else
      render json: {error: result.error_message}, status: 500
    end
  end

  def get_activities_by_conditions
    activities = LoanActivity.where(
      activity_type: loan_activity_params[:activity_type],
      name: loan_activity_params[:name],
      loan_id: loan_activity_params[:loan_id]
    )
    render json: {activities: activities}, status: 200
  end

  private

  def loan_activity_params
    loan_activity_params = params.require(:loan_activity).permit(:name, :activity_type, :activity_status, :user_visible, :loan_id, :loan_member_id)
    loan_activity_params[:activity_type] = loan_activity_params[:activity_type].to_i
    loan_activity_params[:activity_status] = loan_activity_params[:activity_status].to_i
    loan_activity_params
  end

  def loan
    # WILLDO: Get loan list which staff handles
    @loan ||= Loan.first
  end

  def loan_member
    @loan_member ||= current_user.loan_member
  end
end
