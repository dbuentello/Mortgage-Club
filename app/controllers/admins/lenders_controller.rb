class Admins::LendersController < Admins::BaseController
  before_action :load_lender, only: [:edit, :update, :destroy]

  def index
    bootstrap(lenders: Lender.all)

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def new
    bootstrap(
      lender: Lender.new
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def create
    @lender = Lender.new(lender_params)

    if @lender.save
      render json: @lender
    else
      render json: {message: @lender.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def edit
    bootstrap(
      lender: @lender
    )

    respond_to do |format|
      format.html { render template: 'admin_app' }
    end
  end

  def update
    if @lender.update(lender_params)
      render json: {}
    else
      render json: {message: @lender.errors.full_messages.first}, status: :unprocessable_entity
    end
  end

  def destroy
    @lender.destroy
    render json: {}
  end

  private

  def lender_params
    params.permit(Lender::PERMITTED_ATTRS)
  end

  def load_lender
    @lender = Lender.find(params[:id])
  end
end