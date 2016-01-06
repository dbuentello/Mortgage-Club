class LoanMembers::DashboardController < LoanMembers::BaseController
  before_action :set_loan, only: [:show]
  before_action :authenticate_loan!

  def show
    loan_activities = LoanActivity.get_latest_by_loan(@loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    @loan.closing ||= Closing.create(name: 'Closing', loan_id: @loan.id)

    bootstrap(
      loan: LoanMembers::LoanPresenter.new(@loan).show,
      first_activity: first_activity(@loan),
      loan_activities: loan_activities ? loan_activities.group_by(&:activity_type) : [],
      borrower: LoanMembers::BorrowerPresenter.new(@loan.borrower).show,
      property: LoanMembers::PropertyPresenter.new(@loan.subject_property).show,
      closing: LoanMembers::ClosingPresenter.new(@loan.closing).show,
      templates: LoanMembers::TemplatesPresenter.new(Template.all).show,
      lender_templates: get_lender_templates,
      other_lender_template: get_other_template,
      competitor_rates: {down_payment_25: get_all_rates_down_payment("0.25"),
        down_payment_20: get_all_rates_down_payment("0.2"),
        down_payment_10: get_all_rates_down_payment("0.1"),
        down_payment_3_5: get_all_rates_down_payment("0.035")
        }.as_json
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  private

  def get_all_rates_down_payment(percent)
    @loan.rate_comparisons.where(down_payment_percentage: percent)
  end

  def get_lender_templates
    return [] unless @loan.lender
    LoanMembers::LenderTemplatesPresenter.new(@loan.lender.lender_templates.where(is_other: false)).show
  end

  def get_other_template
    return [] unless @loan.lender
    LoanMembers::LenderTemplatePresenter.new(@loan.lender.lender_templates.where(is_other: true).last).show
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