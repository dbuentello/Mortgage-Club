class LoanMembers::DashboardController < LoanMembers::BaseController
  before_action :set_loan, only: [:show]
  before_action :authenticate_loan!

  def show
    loan_activities = LoanActivity.get_latest_by_loan(@loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    @loan.closing ||= Closing.create(name: 'Closing', loan_id: @loan.id)

    bootstrap(
      loan: LoanPresenter.new(@loan).show_loan_activities,
      first_activity: first_activity(@loan),
      loan_activities: loan_activities ? loan_activities.group_by(&:activity_type) : [],
      borrower: BorrowerPresenter.new(@loan.borrower).show,
      property: PropertyPresenter.new(@loan.subject_property).show,
      closing: ClosingPresenter.new(@loan.closing).show,
      templates: TemplatesPresenter.index(Template.all),
      lender_templates: LenderTemplatesPresenter.index(@loan.lender.lender_templates.order(:is_other))
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  private

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