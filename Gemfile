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
gem 'turbolinks'
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

gem 'blacklight_range_limit', '~> 5.2.0'
# gem 'blacklight_range_limit', :github => 'dtulibrary/blacklight_range_limit'

gem 'honeypot-captcha'
gem 'capistrano', '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-passenger', '~> 0.2'

gem 'dalli'
gem 'bibtex-ruby'
gem 'citeproc-ruby'
gem 'csl-styles'
gem 'netaddr'
gem 'openurl'
gem 'sqlite3'
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x
gem 'sitemap_generator'

group :development do
  #gem 'foreman'
  #gem 'puma'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'http_logger'
  gem 'quiet_assets'
end

group :assets do
  gem 'uglifier', '>= 1.3.0'
  gem 'sprockets', '~> 2.8'
  gem 'therubyracer', '0.12.1', platforms: :ruby
  gem 'libv8', '3.16.14.7'
  gem 'autoprefixer-rails'
end

group :development, :test do
  gem 'spring'
  # gem 'web-console', '~> 2.0'
  gem 'xray-rails'
  gem 'pry', '~> 0.10.1'
  gem 'minitest'
  gem 'addressable'
  gem 'byebug'
end

group :test do
  gem 'rspec-rails'
  gem 'launchy'
  gem 'capybara'
  gem 'capybara-webkit'
end

gem 'rsolr'
gem 'devise'
gem 'devise-guests', '~> 0.3'
gem 'solr_wrapper', github: 'flyingzumwalt/solr_wrapper'
gem 'dtu_blacklight_common', github:'dtulibrary/dtu_blacklight_common', branch: 'blacklight5.16'

gem 'blacklight', '~> 5.16'
gem 'blacklight-spotlight', tag: 'v0.16.0', github: 'sul-dlss/spotlight'
gem 'blacklight-gallery' # necessary for spotlight
