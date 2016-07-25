class Admins::DocusignTemplateManagementsController < Admins::BaseController
  before_action :set_docusign_template, except: [:index, :create]

  def index
    docusign_templates = Template.all

    bootstrap(
      docusign_templates: Admins::DocusignTemplatesPresenter.new(docusign_templates).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(
      docusign_template: Admins::DocusignTemplatePresenter.new(@docusign_template).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @docusign_template.update(docusign_template_params)
      render json: {docusign_template: Admins::DocusignTemplatePresenter.new(@docusign_template).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @docusign_template = Template.new(docusign_template_params)

    if @docusign_template.save
      render json: {
        docusign_template: Admins::DocusignTemplatePresenter.new(@docusign_template).show,
        docusign_templates: Admins::DocusignTemplatesPresenter.new(Template.all).show,
        message: t("info.success", status: t("common.status.created"))
      }, status: 200
    else
      render json: {message: @docusign_template.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @docusign_template.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        docusign_templates: Admins::DocusignTemplatesPresenter.new(Template.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove"))}, status: 500
    end
  end

  private

  def docusign_template_params
    params.require(:docusign_template).permit(:name, :state, :description, :email_subject, :email_body, :docusign_id, :document_order)
  end

  def set_docusign_template
    @docusign_template = Template.find(params[:id])
  end
end
