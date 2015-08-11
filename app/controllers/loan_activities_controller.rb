class LoanActivitiesController < ApplicationController
  layout 'admin'

  before_action :verify_loan_member

  def index
    @loans ||= Loan.preload(:user)

    bootstrap(loans: @loans.as_json(loans_json_options))

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def show
    loan_activities = LoanActivity.get_latest_by_loan(loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    bootstrap(
      loan: loan.as_json(loans_json_options),
      first_activity: first_activity,
      loan_activities: loan_activities ? loan_activities.group_by(&:activity_type) : [],
      property: loan.property.as_json(property_json_options)
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
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
      loan_activities = LoanActivity.where(
        loan_id: loan_activity_params[:loan_id],
        activity_type: loan_activity_params[:activity_type],
        name: loan_activity_params[:name]
      ).includes(loan_member: :user).
      order(created_at: :desc).limit(1)
    else
      loan_activities = LoanActivity.get_latest_by_loan_and_conditions(loan_activity_params)
      ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)
    end

    render json: {activities: loan_activities}, status: 200
  end

  private

  def verify_loan_member
    redirect_to root_url unless current_user.loan_member?
  end

  def loan_activity_params
    loan_activity_params = params.require(:loan_activity).permit(
      :name, :activity_type, :activity_status, :user_visible, :loan_id
    )

    loan_activity_params[:activity_type] = loan_activity_params[:activity_type].to_i
    loan_activity_params[:activity_status] = loan_activity_params[:activity_status].to_i
    loan_activity_params
  end

  def loan
    # WILLDO: Get loan list which loan member handles
    @loan ||= Loan.find(params[:id])
  end

  def loan_member
    @loan_member ||= current_user.loan_member
  end

  def first_activity
    # activity_status: -1 => not existed yet
    LoanActivity.where(name: LoanActivity::LIST.values[0][0], loan_id: loan.id).last || { activity_status: -1 }
  end

  def loans_json_options
    {
      include: {
        borrower: {
          include: [
            :first_bank_statement, :second_bank_statement,
            :first_paystub, :second_paystub,
            :first_w2, :second_w2
          ]
        },
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        }
      }
    }
  end

  def property_json_options
    {
      include: [
        :appraisal_report, :flood_zone_certification, :homeowners_insurance,
        :inspection_report, :lease_agreement, :mortgage_statement,
        :purchase_agreement, :risk_report, :termite_report, :title_report
      ]
    }
  end
end
