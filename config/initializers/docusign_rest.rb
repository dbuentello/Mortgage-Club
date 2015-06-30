require 'docusign_rest'

DocusignRest.configure do |config|
  config.username       = ENV['DOCUSIGN_API_USERNAME']
  config.password       = ENV['DOCUSIGN_API_PASSWORD']
  config.integrator_key = ENV['DOCUSIGN_API_INTEGRATOR_KEY']
  # config.account_id     = ENV['DOCUSIGN_API_ACCOUNT_ID']
  config.endpoint       = 'https://demo.docusign.net/restapi'
  config.api_version    = 'v2'
end