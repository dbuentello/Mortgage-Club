class Admins::LenderTemplatesController < Admins::BaseController
  before_action :load_lender
  before_action :load_template, only: [:edit, :update, :destroy]

  def index
    bootstrap(lender: @lender,
              templates: @lender.lender_templates)

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def create
    template = LenderTemplate.new(template_params)
    requirement = template.lender_template_requirements.build(lender: @lender)

    if requirement.save
      render json: template
    else
      render json: {message: requirement.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def edit
    bootstrap(
      lender: @lender,
      template: @template
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @template.update(template_params)
      render json: {}
    else
      render json: {message: @template.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    render json: {}
  end

  private

  def template_params
    params.permit(LenderTemplate::PERMITTED_ATTRS)
  end

  def load_lender
    @lender = Lender.find(params[:lender_id])
  end

  def load_template
    @template = @lender.lender_templates.find(params[:id])
  end
end