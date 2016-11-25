class LoanMembers::DashboardController < LoanMembers::BaseController
  before_action :set_loan, only: [:show]

  def show
    loan_activities = LoanActivity.get_latest_by_loan(@loan)
    ActiveRecord::Associations::Preloader.new.preload(loan_activities, loan_member: :user)

    @loan.closing ||= Closing.create(name: 'Closing', loan_id: @loan.id)

    subject_property = @loan.properties.includes(:documents).find { |p| p.is_subject == true }

    host_name = ENV.fetch("HOST_NAME", "localhost:4000")
    url = edit_user_password_url(host: host_name)

    bootstrap(
      loan: LoanMembers::LoanPresenter.new(@loan).show,
      first_activity: first_activity(@loan),
      activity_types: LoanMembers::ActivityTypesPresenter.new(ActivityType.all.order(order_number: :asc)).show,
      loan_activities: loan_activities,
      borrower: LoanMembers::BorrowerPresenter.new(@loan.borrower).show,
      property: LoanMembers::PropertyPresenter.new(subject_property).show,
      closing: LoanMembers::ClosingPresenter.new(@loan.closing).show,
      templates: LoanMembers::TemplatesPresenter.new(Template.all).show,
      checklists: LoanMembers::ChecklistsPresenter.new(@loan.checklists.order(due_date: :desc, name: :asc)).show,
      list_emails: LoanMembers::MessagesPresenter.new(Message.where(loan_id: @loan.id).order(created_at: :desc)).show,
      loan_emails: get_loan_emails,
      loan_member: current_user,
      url: url
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  def send_email
    LoanMemberDashboardMailer.remind_checklists(current_user, params).deliver_now
    # SendGrid::LoanTest.call(current_user, params)

    render json: {list_emails: LoanMembers::MessagesPresenter.new(Message.where(loan_id: params[:loan_id]).order(created_at: :desc)).show}
  end

  def get_email_templates
    host_name = ENV.fetch("HOST_NAME", "localhost:4000")

    @loan = Loan.find(params[:id])
    @first_name = @loan.borrower.user.first_name
    @user_email = @loan.borrower.user.email
    @current_user = current_user
    @closing_date = @loan.closing_date.present? ? @loan.closing_date : @loan.created_at + 21.days
    @checklists = @loan.checklists.where(status: "pending").order(created_at: :asc)
    @due_date = @checklists.last.present? ? @checklists.last.due_date : Time.zone.now + 21.days
    @reset_password_link = @loan.prepared_loan_token.present? ? Rails.application.routes.url_helpers.edit_user_password_url(reset_password_token: @loan.prepared_loan_token, host: host_name) : GeneratePreparedLoanUrlTokenService.call(@loan)

    default_template = render_to_string "email_templates/default", layout: false
    new_loan_template = render_to_string "email_templates/new_loan_file_setup", layout: false
    complete_loan_template = render_to_string "email_templates/complete_loan_file", layout: false
    incomplete_loan_template = render_to_string "email_templates/incomplete_loan_file", layout: false
    submit_loan_to_lender_template = render_to_string "email_templates/submit_loan_to_lender", layout: false
    submit_loan_to_underwritting_template = render_to_string "email_templates/submit_loan_to_underwritting", layout: false
    lock_in_rate_template = render_to_string "email_templates/lock_in_rate", layout: false
    conditional_approval_template = render_to_string "email_templates/conditional_approval", layout: false
    delay_closing_date_template = render_to_string "email_templates/delay_closing_date", layout: false
    appraisal_appointment_template = render_to_string "email_templates/appraisal_appointment", layout: false
    remind_checklists = render_to_string "email_templates/remind_checklists", layout: false
    final_approval_template = render_to_string "email_templates/final_approval", layout: false
    funding_template = render_to_string "email_templates/funding", layout: false

    render json: {
      default_template: {
        value: default_template,
        subject: "Your loan application for #{@loan.subject_property.address.address}"
      },
      new_loan_template: {
        value: new_loan_template,
        subject: "[ACTION NEEDED] Your loan application with MortgageClub"
      },
      complete_loan_template: {
        value: complete_loan_template,
        subject: "[ACTION NEEDED] Your loan application with MortgageClub"
      },
      incomplete_loan_template: {
        value: incomplete_loan_template,
        subject: "[ACTION NEEDED] Your loan application with MortgageClub"
      },
      submit_loan_to_lender_template: {
        value: submit_loan_to_lender_template,
        subject: "[Status Update] Your loan application for #{@loan.subject_property.address.address}"
      },
      submit_loan_to_underwritting_template: {
        value: submit_loan_to_underwritting_template,
        subject: "[Status Update] Your loan application for #{@loan.subject_property.address.address}"
      },
      lock_in_rate_template: {
        value: lock_in_rate_template,
        subject: "[Status Update] Your loan application for #{@loan.subject_property.address.address}"
      },
      conditional_approval_template: {
        value: conditional_approval_template,
        subject: "[Status Update] Your refinance loan for #{@loan.subject_property.address.address}"
      },
      delay_closing_date_template: {
        value: delay_closing_date_template,
        subject: "[Status Update] Your refinance loan for #{@loan.subject_property.address.address}"
      },
      appraisal_appointment_template: {
        value: appraisal_appointment_template,
        subject: "[Status Update] Your refinance loan for #{@loan.subject_property.address.address}"
      },
      checklist_items_template: {
        value: remind_checklists,
        subject: "[ACTION NEEDED] Your loan application for #{@loan.subject_property.address.address}"
      },
      final_approval_template: {
        value: final_approval_template,
        subject: "[ACTION NEEDED] Your refinance loan for #{@loan.subject_property.address.address}"
      },
      funding_template: {
        value: funding_template,
        subject: "[Status Update] Your refinance loan for #{@loan.subject_property.address.address}"
      }
    }
  end

  private

  def get_loan_emails
    emails = []
    emails << {
      "key" => "Borrower <#{@loan.borrower.user.email}>",
      "value" => @loan.borrower.user.email
    }

    if @loan.secondary_borrower
      emails << {
        "key" => "Co-borrower <#{@loan.secondary_borrower.user.email}>",
        "value" => @loan.secondary_borrower.user.email
      }
    end

    @loan.loans_members_associations.each do |loans_members_association|
      emails << {
        "key" => "#{loans_members_association.loan_members_title.title} <#{loans_members_association.loan_member.user.email}>",
        "value" => loans_members_association.loan_member.user.email
      }
    end

    emails
  end

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
    first_activity_type = ActivityType.order(order_number: :asc).first
    LoanActivity.where(name: first_activity_type.activity_names.first.name, loan_id: loan.id).order(created_at: :desc).limit(1).first || {activity_status: -1}
  end
end
