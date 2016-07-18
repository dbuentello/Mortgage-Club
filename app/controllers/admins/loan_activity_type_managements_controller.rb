class Admins::LoanActivityTypeManagementsController < Admins::BaseController
  before_action :set_activity_type, except: [:index, :create]

  def index
    activity_types = ActivityType.all.order(order_number: :asc)

    bootstrap(
      activity_types: Admins::LoanActivityTypesPresenter.new(activity_types).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    bootstrap(
      activity_type: Admins::LoanActivityTypePresenter.new(@activity_type).show
    )

    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def update
    if @activity_type.update(activity_type_params)
      render json: {activity_type: Admins::LoanActivityTypePresenter.new(@activity_type).show, message: t("info.success", status: t("common.status.updated"))}, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.update"))}, status: 500
    end
  end

  def create
    @activity_type = ActivityType.new(activity_type_params)

    if @activity_type.save
      render json: {
        activity_type: Admins::LoanActivityTypePresenter.new(@activity_type).show,
        activity_types: Admins::LoanActivityTypesPresenter.new(ActivityType.all.order(order_number: :asc)).show,
        message: t("info.success", status: t("created"))
      }, status: 200
    else
      render json: {message: @activity_type.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @activity_type.destroy
      render json: {
        message: t("info.success", status: t("common.status.removed")),
        activity_types: Admins::LoanActivityTypesPresenter.new(ActivityType.all.order(order_number: :asc)).show
      }, status: 200
    else
      render json: {message: t("errors.failed", process: t("common.process.remove_checklist"))}, status: 500
    end
  end

  private

  def activity_type_params
    params.require(:activity_type).permit(:label, :order_number, type_name_mapping: [])
  end

  def set_activity_type
    @activity_type = ActivityType.find(params[:id])
  end
end
