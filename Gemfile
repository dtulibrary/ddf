source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
gem 'activerecord-session_store'

# Use postgresql as the database for Active Record
gem 'pg'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
gem 'sass-rails', '~> 5.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
group :development, :production do
  gem 'turbolinks' # turbolinks causing issues with tests...
end
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'json', '1.8.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'blacklight', '~> 5.7.1'
gem 'blacklight_range_limit', :github => 'dtulibrary/blacklight_range_limit'
gem 'honeypot-captcha'
gem 'capistrano', '~> 2.0'

gem 'dalli'
gem 'bibtex-ruby'
gem 'citeproc-ruby'
gem 'csl-styles'
gem 'netaddr'
gem 'openurl'
gem 'sqlite3'
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x
gem 'sitemap_generator'
gem 'lograge'

group :development do
  #gem 'foreman'
  #gem 'puma'
  gem 'byebug'
  gem 'http_logger'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'quiet_assets'
end

group :assets do
  gem 'uglifier'
  gem 'sprockets', '~> 2.8'
  gem 'therubyracer', '0.12.1', platforms: :ruby
  gem 'libv8', '3.16.14.7'
  gem 'autoprefixer-rails'
end

group :development, :test do
  gem 'spring'
  gem 'metastore-test_data', :github => 'dtulibrary/metastore-test_data'

  # gem 'web-console', '~> 2.0'
  gem 'xray-rails'
  gem 'pry', '~> 0.10.1'
  gem 'minitest'
  gem 'addressable'
end

group :test do
  gem 'rspec-rails'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
end

gem 'rsolr', '~> 1.0.6'
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'solr_wrapper', github: 'flyingzumwalt/solr_wrapper'
gem 'dtu_blacklight_common', '~> 5.7.1.10', github: 'dtulibrary/dtu_blacklight_common'
gem 'dtu_monitoring', '~> 1.2.0', :github => 'dtulibrary/dtu_monitoring'
gem 'delayed_job_active_record'