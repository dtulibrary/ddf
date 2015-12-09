class Util < Thor
  include Thor::Actions
  desc 'launch_prod', 'a simple task to configure your local app to run in production mode for test purposes'
  def launch_prod
    say_status('info', 'Setting up your local app to run in production', :green)
    puts 'Configuring "secret" keys...'
    gsub_file 'config/initializers/blacklight_initializer.rb', "# Blacklight.secret_key", "Blacklight.secret_key"
    gsub_file 'config/initializers/devise.rb', '# config.secret_key', 'config.secret_key'
    say_status('info', 'Compiling assets', :green)
    system('rake assets:precompile')
    say_status('info', 'Setting environment variables', :green)
    ENV['RAILS_ENV'] = 'production'
    ENV['SECRET_KEY_BASE'] = 'BLABLBLABABLABLABLABLABLABALBALALBABLABA'
    ENV['RAILS_SERVE_STATIC_FILES'] = 'true'
    ENV['SOLR_URL'] = 'http://lb.production.metastore.cvt.dk/solr/metastore'
    system('bin/rails s')
  end

  desc 'revert_prod', 'return app to normal state'
  def revert_prod
    say_status('info', "Removing secret keys...", :green)
    gsub_file 'config/initializers/blacklight_initializer.rb', /^Blacklight\.secret_key/, '# Blacklight.secret_key'
    gsub_file 'config/initializers/devise.rb', /config\.secret_key/, '# config.secret_key'
  end
end
