class LoanMembers::LoanActivitiesController < LoanMembers::BaseController
  before_action :set_loan, only: [:show, :update, :destroy]

  def index
    loans ||= Loan.preload(:user)

    bootstrap(loans: LoansPresenter.new(loans).show_loans)

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  def show
    loan_activities = LoanActivity.get_latest_by_loan(@loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    @loan.closing ||= Closing.create(name: 'Closing', loan_id: @loan.id)

    bootstrap(
      loan: LoanPresenter.new(@loan).show_loan_activities,
      first_activity: first_activity(@loan),
      loan_activities: loan_activities ? loan_activities.group_by(&:activity_type) : [],
      property: PropertyPresenter.new(@loan).show_property,
      closing: ClosingPresenter.new(@loan.closing).show_closing
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end

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
    if loan_activity_params[:name].present?
      loan_activities = [LoanActivity.where(
        loan_id: loan_activity_params[:loan_id],
        activity_type: loan_activity_params[:activity_type],
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
      :name, :activity_type, :activity_status, :user_visible, :loan_id
    )

    loan_activity_params[:activity_type] = loan_activity_params[:activity_type].to_i
    loan_activity_params[:activity_status] = loan_activity_params[:activity_status].to_i
    loan_activity_params
  end

  def loan_member
    @loan_member ||= current_user.loan_member
  end

  def first_activity(loan)
    # activity_status: -1 => not existed yet
    LoanActivity.where(name: LoanActivity::LIST.values[0][0], loan_id: loan.id).order(created_at: :desc).limit(1).first || {activity_status: -1}
  end



end
