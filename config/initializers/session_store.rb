# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_ddf_session'

Ddf::Application.config.session_store :active_record_store, { :key => '_ddf_session' }
# require "#{Rails.root}/lib/blacklight/catalog/search_context.rb"

