class ApplicationController < ActionController::Base
  include Pundit
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :prepare_meta_tags, if: "request.get?"
  before_action :set_mixpanel_token

  def find_root_path
    return unauthenticated_root_path unless current_user
    return admin_root_path if current_user.has_role?(:admin)
    return loan_member_root_path if current_user.has_role?(:lender_member)
    borrower_root_path
  end

  private

  def after_sign_in_path_for(resource)
    return super unless resource.borrower?
    return super unless params[:user].present? && params[:user][:reset_password_token].present?
    return super unless loan = Loan.find_by(prepared_loan_token: params[:user][:reset_password_token])

    edit_loan_path(loan)
  end

  def user_not_authorized
    @back_to_home_path = find_root_path
    render "errors/403.html", status: 403
  end

  # Find loan by loan_id (co_borrower/secondary_borrower) or id ( borrower )
  # first time co_borrower log in the system, will get loan from borrower.
  #
  # @return [Object] @loan
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
    # use pundit to authorize user. check LoanPolicy
    authorize @loan, :update?
  end

  def set_mixpanel_token
    @mixpanel_token = ENV["MIXPANEL_TOKEN"]
  end

  def bootstrap(data = {})
    @bootstrap_data =
    {
      currentUser: current_user.present? ? {id: current_user.id, firstName: current_user.first_name, lastName: current_user.last_name} : {},
      flashes: customized_flash
    }.merge!(data)
  end

  def customized_flash
    customized_flash = {}
    flash.each do |msg_type, message|
      type = bootstrap_class_for(msg_type)

      customized_flash[type] = message if type.present?
    end

    customized_flash
  end

  # Set og of facebook to system. Use 'gem meta-tags'
  #
  # @param [Type] options = {} describe options = {}
  # @return [Type] description of returned object
  def prepare_meta_tags(options = {})
    site_name   = "MortgageClub"
    title       = "We’re a tech-enabled mortgage broker." # ["controller_name", "action_name"].join(" ")
    description = "Find your rate in 10s, apply in 10 mins, close in 21 days. Let's get started!"
    image       = options[:image] || (request.base_url + ActionController::Base.helpers.asset_path('open-graph-new.jpg'))

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
