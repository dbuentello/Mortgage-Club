class Admins::LoanActivityNameManagementsController < Admins::BaseController
  before_action :set_activity_name, except: [:index, :create]

  def index
    activity_names = ActivityName.all
    activity_types = ActivityType.all

    bootstrap(
      activity_names: Admins::LoanActivityNamesPresenter.new(activity_names).show,
      activity_types: Admins::LoanActivityTypesPresenter.new(activity_types).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    activity_types = ActivityType.all

    bootstrap(
      activity_name: Admins::LoanActivityNamePresenter.new(@activity_name).show,
      activity_types: Admins::LoanActivityTypesPresenter.new(activity_types).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    if @activity_name.update(activity_name_params)
      render json: {activity_name: Admins::LoanActivityNamePresenter.new(@activity_name).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @activity_name = ActivityName.new(activity_name_params)

    if @activity_name.save
      render json: {
        activity_name: Admins::LoanActivityNamePresenter.new(@activity_name).show,
        activity_names: Admins::LoanActivityNamesPresenter.new(ActivityName.all).show,
        message: t("info.success", status: t("created"))
      }, status: 200
    else
      render json: {message: @activity_name.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @activity_name.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        activity_names: Admins::LoanActivityNamesPresenter.new(ActivityName.all).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove_checklist"))}, status: 500
    end
  end

  private

  def activity_name_params
    params.require(:activity_name).permit(:name, :activity_type_id, :notify_borrower_text, :notify_borrower_text_body, :notify_borrower_email, :notify_borrower_email_subject, :notify_borrower_email_body)
  end

  def set_activity_name
    @activity_name = ActivityName.find(params[:id])
  end
end
