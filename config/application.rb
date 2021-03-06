require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ddf
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib/document)
    config.eager_load_paths += %W(#{config.root}/lib/document)
    config.railties_order = [:main_app, Blacklight::Engine, :all]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.solr_document = { :document_id => 'cluster_id_ss' }

    config.sitemap = {
      :generate         => false,
      :host             => '',
      :dedup_source_url => '',
    }

    config.log_tags = [:remote_ip]

    config.x.open_access.url = 'http://oa-indicator.cvt.dk/oa-indicator/ws/%{resource}.%{format}/%{year}/%{profile}'
    config.x.open_access.status_api = 'http://oa-indicator.cvt.dk/oa-indicator/ws/status'
    config.x.open_access.api_profile = 'prod'
    config.x.open_access.last_available_year = 2014
    config.x.open_access.total_years = (2013..2021)
    config.x.open_access.report_url = 'http://oa-indicator.cvt.dk/oa-indicator-runs/%{year}.%{profile}/spreadsheets/%{lang}/%{filename}'
    config.x.open_access.report_name = 'OA-Indicator_%{year}_%{lang}_%{report}.xlsx'
  end
end
