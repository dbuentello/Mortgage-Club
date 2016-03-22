class Admins::LoanFaqManagementsController < Admins::BaseController
  before_action :set_faq, except: [:index, :create]

  def index
    faqs = Faq.all

    bootstrap(
      faqs: Admins::LoanFaqsPresenter.new(faqs).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def edit
    bootstrap(
      faq: Admins::LoanFaqPresenter.new(@faq).show
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @faq.update(faq_params)
      render json: {faq: Admins::LoanFaqPresenter.new(@faq).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      render json: {
        faq: Admins::LoanFaqPresenter.new(@faq).show,
        faqs: Admins::LoanFaqsPresenter.new(Faq.all).show,
        message: t("info.success", status: t("common.status.created"))
      }, status: 200
    else
      render json: {message: @faq.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @faq.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        faqs: Admins::LoanFaqsPresenter.new(Faq.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove"))}, status: 500
    end
  end

  private

  def faq_params
    params.require(:faq).permit(:question, :answer)
  end

  def set_faq
    @faq = Faq.find(params[:id])
  end
end
