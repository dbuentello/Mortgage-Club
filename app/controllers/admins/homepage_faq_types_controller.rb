class Admins::HomepageFaqTypesController < Admins::BaseController
  before_action :set_homepage_faq_type, except: [:index, :create]

  def index
    homepage_faq_types = HomepageFaqType.all

    bootstrap(
      homepage_faq_types: Admins::HomepageFaqTypesPresenter.new(homepage_faq_types).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    bootstrap(
      homepage_faq_type: Admins::HomepageFaqTypePresenter.new(@homepage_faq_type).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    if @homepage_faq_type.update(homepage_faq_type_params)
      render json: {homepage_faq_type: Admins::HomepageFaqTypePresenter.new(@homepage_faq_type).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @homepage_faq_type = HomepageFaqType.new(homepage_faq_type_params)

    if @homepage_faq_type.save
      render json: {
        homepage_faq_type: Admins::HomepageFaqTypePresenter.new(@homepage_faq_type).show,
        homepage_faq_types: Admins::HomepageFaqTypesPresenter.new(HomepageFaqType.all).show,
        message: t("info.success", status: t("created"))
      }, status: 200
    else
      render json: {message: @homepage_faq_type.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @homepage_faq_type.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        homepage_faq_types: Admins::HomepageFaqTypesPresenter.new(HomepageFaqType.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove_checklist"))}, status: 500
    end
  end

  private

  def homepage_faq_type_params
    params.require(:homepage_faq_type).permit(:name)
  end

  def set_homepage_faq_type
    @homepage_faq_type = HomepageFaqType.find(params[:id])
  end
end
