class PagesController < ApplicationController
  def index
    app({})
  end
private
  def app(data={})

    @bootstrap_data = {
      currentUser: current_user.present? ? {
        id: current_user.id,
        firstName: current_user.first_name,
        lastName: current_user.last_name
      } : nil
    }.merge!(data)

    respond_to do |format|
      format.html { render template: 'pages/app' }
    end
  end
end
