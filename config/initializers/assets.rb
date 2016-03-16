# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( init.js jquery.js zopim.js public.js admin.js admin-pages.css loan_member.js loan-members.css )

# Add webpack/assets/stylesheets to asset pipeline's search path.
Rails.application.config.assets.paths << Rails.root.join("client", "assets" ,"stylesheets")
