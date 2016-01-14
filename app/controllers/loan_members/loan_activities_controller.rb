class LoanMembers::LoanActivitiesController < LoanMembers::BaseController
  before_action :set_loan, only: [:show, :update, :destroy]

  def create
    loan = Loan.find_by_id(loan_activity_params[:loan_id])

    result = LoanActivityServices::CreateActivity.new.call(loan_member, loan_activity_params)
    if result.success?
      render json: {activities: LoanActivity.get_latest_by_loan(loan), success: "Success"}, status: 200
    else
      render json: {error: result.error_message}, status: 500
    end
  end

  def get_activities_by_conditions
    if loan_activity_params[:name].present?
      loan_activities = [LoanActivity.where(
        loan_id: loan_activity_params[:loan_id],
        activity_type_id: loan_activity_params[:activity_type_id],
        name: loan_activity_params[:name]
      ).includes(loan_member: :user).
      order(created_at: :desc).limit(1).first]
    else
      loan_activities = LoanActivity.get_latest_by_loan_and_conditions(loan_activity_params)
      ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)
    end

    render json: {activities: loan_activities}, status: 200
  end

  private

  def loan_activity_params
    loan_activity_params = params.require(:loan_activity).permit(
      :name, :activity_type_id, :activity_status, :user_visible, :loan_id
    )

    loan_activity_params[:activity_status] = loan_activity_params[:activity_status].to_i
    loan_activity_params[:start_date] = Time.zone.now
    loan_activity_params
  end

  def loan_member
    @loan_member ||= current_user.loan_member
  end
end
