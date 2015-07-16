class RatesController < ApplicationController
  def index
    bootstrap

    respond_to do |format|
      format.html { render template: 'client_app' }
      format.json { render json: Rate.get_rates }
    end
  end

  def select
    # NEED_TODO
    render json: { message: "hehe" }, status: :ok
  end

end
