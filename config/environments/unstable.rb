load File.dirname(__FILE__) + '/production.rb'

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'spotlight.ddf.dtic.dk' }
end

if File.exists? File.dirname(__FILE__) + '/../application.local.rb'
  require File.dirname(__FILE__) + '/../application.local.rb'
end
