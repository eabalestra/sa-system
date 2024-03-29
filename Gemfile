# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use AWS SDK for Ruby
gem "aws-sdk-s3"

# Use jquery as the JavaScript librar
gem "jquery-rails"

# Use jquery-ui for pretty UI
gem "jquery-ui-rails"

# Use Sass to process CSS
gem "sassc-rails"

#
gem "bootstrap"

# Use devise for authentication
gem "devise"

# Generate receipts docs
gem "rubyXL"

# Use will_paginate for pagination
gem "will_paginate", "~> 4.0"

# Graphs
gem "chartkick", "~> 5.0"
gem "groupdate", "~> 6.4"

# Use libreconv for generate pdfs from receipts
gem "libreconv"

group :production do
  # Database adapter for PostgreSQL
  gem "pg"
  # Ruby wrapper for the ImageMagick and GraphicsMagick image processing libraries
  gem "ruby-vips", "~> 2.2"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]

  # Use sqlite3 as the database for Active Record
  gem "sqlite3", "~> 1.4"
  gem "factory_bot_rails"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  #
  gem "htmlbeautifier"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "rspec-rails", "~> 6.1"
  gem "simplecov", "~> 0.22.0", :require => false
  gem "simplecov_json_formatter", "~> 0.1.4", :group => :test, :require => false
end

gem "dockerfile-rails", ">= 1.6", :group => :development
