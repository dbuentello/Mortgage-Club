class Admins::LenderDocusignFormsController < Admins::BaseController
  before_action :set_lender
  before_action :set_lender_docusign_form, only: [:edit, :update, :destroy]

  def index
    bootstrap(
      lender: @lender,
      lender_docusign_forms: LenderDocusignForm.where(lender_id: @lender.id))

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def new
    bootstrap(lender_docusign_form: LenderDocusignForm.new)

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def create
    @lender_docusign_form = LenderDocusignForm.new(lender_docusign_form_params)

    if @lender_docusign_form.save
      render json: @lender_docusign_form
    else
      render json: {message: @lender_docusign_form.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def edit
    bootstrap(lender: @lender, lender_docusign_form: @lender_docusign_form)

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @lender_docusign_form.update(lender_docusign_form_params)
      render json: @lender_docusign_form
    else
      render json: {message: @lender_docusign_form.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def destroy
    @lender_docusign_form.destroy
    render json: {}
  end

  private

  def set_lender
    @lender = Lender.find(params[:lender_id])
  end

  def lender_docusign_form_params
    params.permit(LenderDocusignForm::PERMITTED_ATTRS)
  end

  def set_lender_docusign_form
    @lender_docusign_form = LenderDocusignForm.find(params[:id])
  end
end
