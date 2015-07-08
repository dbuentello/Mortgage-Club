# Test card number: 4242 4242 4242 4242
# https://stripe.com/docs/testing#cards

Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_API_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_API_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]