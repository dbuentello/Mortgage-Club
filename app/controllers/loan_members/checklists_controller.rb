class LoanMembers::ChecklistsController < LoanMembers::BaseController
  before_action :set_loan, except: [:edit, :destroy]
  before_action :set_checklist, except: [:index, :create]

  # def index
  #   checklists = Checklist.where(loan_id: @loan.id)

  #   bootstrap(checklists: ChecklistsPresenter.index(checklists))

  #   respond_to do |format|
  #     format.html { render template: 'loan_member_app' }
  #   end
  # end

  def create
    checklist = Checklist.new(checklist_params)
    checklist.user = current_user
    checklist.loan = @loan

    if checklist.save
     render json: {
        checklist: ChecklistsPresenter.show(checklist),
        checklists: ChecklistsPresenter.index(@loan.checklists),
        message: 'Created successfully'
      }, status: 200
    else
      render json: {message: checklist.errors.full_messages.first}, status: 500
    end
  end

  def edit
    bootstrap(
      checklist: ChecklistsPresenter.show(@checklist),
      templates: TemplatesPresenter.index(Template.all)
    )

    respond_to do |format|
      format.html { render template: 'loan_member_app' }
    end
  end

  def update
    if @checklist.update(checklist_params)
      render json: {checklist: ChecklistsPresenter.show(@checklist), message: 'Updated successfully'}, status: 200
    else
      render json: {message: "Updated failed"}, status: 500
    end
  end

  def destroy
    checklist = Checklist.find(params[:id])
    loan = checklist.loan

    if checklist.destroy
      render json: {
        message: "Remove the checklist successfully",
        checklists: ChecklistsPresenter.index(loan.checklists)
      }, status: 200
    else
      render json: {message: "Cannot remove the checklist"}, status: 500
    end
  end

  private

  def checklist_params
    params[:checklist][:due_date] = Date.strptime(params[:checklist][:due_date], "%m/%d/%Y")
    params.require(:checklist).permit(:checklist_type, :document_type, :name, :description, :question, :due_date, :template_id)
  end

  def set_checklist
    @checklist = Checklist.find(params[:id])
  end
end