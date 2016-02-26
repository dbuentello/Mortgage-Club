class Admins::SettingsController <  Admins::BaseController
  before_action :set_title, except: [:index, :create]

  def index
    @settings = Setting.all

    bootstrap(
      settings: @settings
    )
    respond_to do |format|
      format.html { render template: "admin_app" }
    end
  end

  def edit
    bootstrap(
      title: @title
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @title.update(title_params)
      render json: {
        title: @title,
        message: "Update successfully"
      }, status: 200
    else
      render json: {message: @title.errors.full_messages.first}, status: 500
    end
  end

  def create
    @title = LoanMembersTitle.new(title_params)

    if @title.save

      render json: {
        title: @title,
        loan_members_titles: LoanMembersTitle.all
      }, status: 200
    else
      render json: {message: @title.errors.full_messages.first}, status: 500
    end
  end

  def destroy
    if @title.destroy
      render json: {
        message: "Removed the the title successfully",
        loan_members_titles: LoanMembersTitle.all
      }, status: 200
    else
      render json: {message: "Cannot remove the the"}, status: 500
    end
  end

  private

  def title_params
    params.permit(:title)
  end

  def set_title
    @title = LoanMembersTitle.find(params[:id])
  end
end
