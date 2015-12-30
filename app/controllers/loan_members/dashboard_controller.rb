class LoanMembers::DashboardController < LoanMembers::BaseController
  before_action :set_loan, only: [:show]
  before_action :authenticate_loan!

  def show
    loan_activities = LoanActivity.get_latest_by_loan(@loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    @loan.closing ||= Closing.create(name: 'Closing', loan_id: @loan.id)

    bootstrap(
      loan: LoanPresenter.new(@loan).show_at_loan_member_dashboard,
      first_activity: first_activity(@loan),
      loan_activities: loan_activities ? loan_activities.group_by(&:activity_type) : [],
      borrower: BorrowerPresenter.new(@loan.borrower).show,
      property: PropertyPresenter.new(@loan.subject_property).show,
      closing: ClosingPresenter.new(@loan.closing).show,
      templates: TemplatesPresenter.index(Template.all),
      lender_templates: get_lender_templates,
      other_lender_template: get_other_template,
      competitor_rates: get_all_rates.as_json
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  private

  def get_all_rates
    [
      {
        down_payment_percentage: 0.2,
        lender_name: "google",
        rates: [
          {name: "30_year_fixed", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)},
          {name: "20_year_fixed", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)},
          {name: "15_year_fixed", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)},
          {name: "10_year_fixed", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)},
          {name: "7_1_arm", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)},
          {name: "5_1_arm", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)},
          {name: "3_1_arm", apr: Random.rand(40)*0.01, total_fee: Random.rand(1000)}
        ]
      }
    ]

  end

  def get_lender_templates
    return [] unless @loan.lender
    LenderTemplatesPresenter.index(@loan.lender.lender_templates.where(is_other: false))
  end

  def get_other_template
    return [] unless @loan.lender
    LenderTemplatesPresenter.show(@loan.lender.lender_templates.where(is_other: true).last)
  end

  def first_activity(loan)
    # TODO: refactor it
    # activity_status: -1 => not existed yet
    LoanActivity.where(name: LoanActivity::LIST.values[0][0], loan_id: loan.id).order(created_at: :desc).limit(1).first || {activity_status: -1}
  end

  def authenticate_loan!
    if @loan && !current_user.loan_member.handle_this_loan?(@loan)
      redirect_to unauthenticated_root_path, alert: "The page does not exist or you don't have permmission to access!"
    end
  end
end