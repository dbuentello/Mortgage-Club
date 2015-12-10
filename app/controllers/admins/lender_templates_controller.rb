class Admins::LenderTemplatesController < Admins::BaseController
  before_action :load_lender
  before_action :load_lender_template, only: [:edit, :update, :destroy]

  def index
    bootstrap(
      lender: @lender,
      lender_templates: @lender.lender_templates.where(is_other: false),
      docusign_templates: Template.all
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def create
    lender_template = LenderTemplate.new(template_params)
    requirement = lender_template.lender_template_requirements.find_or_initialize_by(lender: @lender)

    if lender_template.save
      render json: lender_template
    else
      render json: {message: lender_template.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def edit
    bootstrap(
      lender: @lender,
      lender_template: @lender_template,
      docusign_templates: Template.all
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @lender_template.update(template_params)
      render json: {}
    else
      render json: {message: @lender_template.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def destroy
    @lender_template.destroy
    render json: {}
  end

  private

  def template_params
    params.permit(LenderTemplate::PERMITTED_ATTRS)
  end

  def load_lender
    @lender = Lender.find(params[:lender_id])
  end

  def load_lender_template
    @lender_template = @lender.lender_templates.find(params[:id])
  end
end