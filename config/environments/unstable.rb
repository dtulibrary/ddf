load File.dirname(__FILE__) + '/production.rb'

if File.exists? File.dirname(__FILE__) + '/../application.local.rb'
  require File.dirname(__FILE__) + '/../application.local.rb'
end
Rails.application.configure do
  config.x.monitoring_id = 'ddf_unstable'
end
