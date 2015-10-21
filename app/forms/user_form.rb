class UserForm
  include ActiveModel::Model

  attr_accessor :user, :params, :skip_confirmation

  validate :validate_attributes

  def assign_value_to_attributes
    user.assign_attributes(user_params)
    set_confirmation if skip_confirmation
  end

  def save
    assign_value_to_attributes
    return false unless valid?

    User.transaction do
      user.save!
    end
  end

  def user
    @user ||= User.new
  end

  def set_confirmation
    user.confirmed_at = Time.zone.now
    user.skip_confirmation_notification!
  end

  private

  def validate_attributes
    add_errors(user.errors) if user.invalid?
  end

  def add_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

  def user_params
    ActionController::Parameters.new(params).require(:user).permit(User::PERMITTED_ATTRS)
  end
end
