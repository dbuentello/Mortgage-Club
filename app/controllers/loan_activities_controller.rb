class LoanActivitiesController < ApplicationController
  layout 'admin'

  def index
    @loan = loan
    loan_activity_list = LoanActivity::LIST

    bootstrap(
      loan: @loan,
      activity_list: loan_activity_list
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    render json: {message: 'okay'}
  end

  def create
    @loan_activity = loan_member.loan_activities.build(loan_activity_params)

    if @loan_activity.save
      render json: {success: "Success"}, status: 200
    else
      render json: {error: @loan_activity.errors.full_messages}, status: 500
    end
  end

  def get_activities_by_type
    activities = LoanActivity.where(
      activity_type: loan_activity_params[:activity_type],
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
