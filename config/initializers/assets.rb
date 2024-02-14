# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += %w( jquery.min.js jquery_ujs.js jquery-ui.min.js jquery.easing.min.js )

Rails.application.config.assets.precompile += %w( bootstrap.min.js popper.js )

Rails.application.config.assets.precompile += %w( sb-admin-2.min.js sb-admin-2.min.css )

Rails.application.config.assets.precompile += %w( sales.css transactions.css all.min.css )

Rails.application.config.assets.precompile += %w( bootstrap.bundle.min.js )
