class LoanMembers::ChecklistsController < LoanMembers::BaseController
  before_action :set_loan, except: [:edit, :destroy]
  before_action :set_checklist, except: [:index, :create]

  def create
    checklist = Checklist.new(checklist_params)
    checklist.user = current_user
    checklist.loan = @loan

    if checklist.save
      render json: {
        checklist: LoanMembers::ChecklistPresenter.new(checklist).show,
        checklists: LoanMembers::ChecklistsPresenter.new(@loan.checklists.order(due_date: :desc, name: :asc)).show,
        message: t("info.success", status: t("common.status.added"))
      }, status: 200
    else
      render json: {message: checklist.errors.full_messages.first}, status: 500
    end
  end

  def edit
    bootstrap(
      checklist: LoanMembers::ChecklistPresenter.new(@checklist).show,
      templates: LoanMembers::TemplatesPresenter.new(Template.all).show
    )

    respond_to do |format|
      format.html { render template: "loan_member_app" }
    end
  end

  def update
    if @checklist.update(checklist_params)
      render json: {checklist: LoanMembers::ChecklistPresenter.new(@checklist).show, message: t("messages.info.success", status: "updated")}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def destroy
    checklist = Checklist.find(params[:id])
    loan = checklist.loan

    if checklist.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        checklists: LoanMembers::ChecklistsPresenter.new(loan.checklists.order(due_date: :desc, name: :asc)).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove"))}, status: 500
    end
  end

  private

  def checklist_params
    params[:checklist][:due_date] = Date.strptime(params[:checklist][:due_date], "%m/%d/%Y") if params[:checklist][:due_date].present?
    params.require(:checklist).permit(:checklist_type, :document_type, :subject_name, :name, :document_description, :due_date, :info, :status)
  end

  def set_checklist
    @checklist = Checklist.find(params[:id])
  end
end
