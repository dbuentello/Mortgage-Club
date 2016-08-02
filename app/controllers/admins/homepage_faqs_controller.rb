class Admins::HomepageFaqsController < Admins::BaseController
  before_action :set_homepage_faq, except: [:index, :create]

  def index
    homepage_faqs = HomepageFaq.all
    homepage_faq_types = HomepageFaqType.all

    bootstrap(
      homepage_faqs: Admins::HomepageFaqsPresenter.new(homepage_faqs).show,
      homepage_faq_types: Admins::HomepageFaqTypesPresenter.new(homepage_faq_types).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    homepage_faq_types = HomepageFaqType.all

    bootstrap(
      homepage_faq: Admins::HomepageFaqPresenter.new(@homepage_faq).show,
      homepage_faq_types: Admins::HomepageFaqTypesPresenter.new(homepage_faq_types).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    if @homepage_faq.update(homepage_faq_params)
      render json: {homepage_faq: Admins::HomepageFaqPresenter.new(@homepage_faq).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @homepage_faq = HomepageFaq.new(homepage_faq_params)

    if @homepage_faq.save
      render json: {
        homepage_faq: Admins::HomepageFaqPresenter.new(@homepage_faq).show,
        homepage_faqs: Admins::HomepageFaqsPresenter.new(HomepageFaq.all).show,
        message: t("info.success", status: t("created"))
      }, status: 200
    else
      render json: {message: @homepage_faq.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @homepage_faq.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        homepage_faqs: Admins::HomepageFaqsPresenter.new(HomepageFaq.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove_checklist"))}, status: 500
    end
  end

  private

  def homepage_faq_params
    params.require(:homepage_faq).permit(:question, :answer, :homepage_faq_type_id)
  end

  def set_homepage_faq
    @homepage_faq = HomepageFaq.find(params[:id])
  end
end
