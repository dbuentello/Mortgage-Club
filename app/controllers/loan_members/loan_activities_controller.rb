class LoanMembers::LoanActivitiesController < LoanMembers::BaseController
  before_action :set_loan, only: [:show, :update, :destroy]

  def index
    @loans ||= Loan.preload(:user)

    bootstrap(loans: @loans.as_json(loans_json_options))

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  def show
    loan_activities = LoanActivity.get_latest_by_loan(@loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    @loan.closing ||= Closing.create(name: 'Closing', loan_id: @loan.id)

    bootstrap(
      loan: @loan.as_json(loan_json_options),
      first_activity: first_activity(@loan),
      loan_activities: loan_activities ? loan_activities.group_by(&:activity_type) : [],
      property: @loan.property.as_json(property_json_options),
      closing: @loan.closing.as_json(closing_json_options)
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

  def loans_json_options
    {
      include: {
        user: {
          only: [ :email ],
          methods: [ :to_s ]
        }
      }
    }
  end

  def loan_json_options
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
        },
        hud_estimate: {}, hud_final: {}, other_loan_reports: {},
        loan_estimate: {}, uniform_residential_lending_application: {}
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

  def closing_json_options
    {
      include: [
        :closing_disclosure, :deed_of_trust, :loan_doc, :other_closing_reports
      ]
    }
  end
end
