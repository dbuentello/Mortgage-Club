class ChargesController < ApplicationController
  def new
  end

  def create
    # byebug

    # Amount in cents
    @amount = 2000

    customer = Stripe::Customer.create(
      :email => 'lehoang1417@gmail.com',
      :card  => params[:stripeToken][:id]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    render json: { message: "Thanks, you paid $20.00!"}

  rescue Stripe::CardError => e
    flash[:error] = e.message
    render json: { message: "Something went wrong!"}
  end
end
