class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :prepare_meta_tags, if: "request.get?"

  def find_root_path
    return unauthenticated_root_path unless current_user
    return admin_root_path if current_user.has_role?(:admin)
    return loan_member_root_path if current_user.has_role?(:lender_member)
    borrower_root_path
  end

  private

  def user_not_authorized
    @back_to_home_path = find_root_path
    render "errors/403.html", status: 403
  end

  def set_loan
    @loan ||= Loan.find(params[:loan_id] || params[:id])
    @borrower_type ||= :borrower

    if @loan.blank?
      @loan = current_user.borrower.loan # or get the co-borrower relationship

      if @loan.present?
        @borrower_type = :secondary_borrower
      else
        @loan = InitializeFirstLoanService.new(current_user).call
      end
    end
    authorize @loan, :update?
  end

  def bootstrap(data={})
     @bootstrap_data = {
      currentUser: current_user.present? ? {
        id: current_user.id,
        firstName: current_user.first_name,
        lastName: current_user.last_name
      } : {},
      flashes: customized_flash
    }.merge!(data)
  end

  def customized_flash
    customized_flash = {}
    flash.each do |msg_type, message|
      type = bootstrap_class_for(msg_type)

      if type.present?
        customized_flash[type] = message
      end
    end

    customized_flash
  end

  def prepare_meta_tags(options={})
    site_name   = "MortgageClub"
    title       = "FREE REFINANCE ALERT" #["controller_name", "action_name"].join(" ")
    description = "MortgageClub leverages big data and advanced technology to replace your loan officer and pass on the savings to you."
    image       = options[:image] || (request.base_url + ActionController::Base.helpers.asset_path('open-graph.png'))

    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end
end
