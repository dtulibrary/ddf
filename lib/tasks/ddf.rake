namespace :ddf do
  desc 'Give a specified user sitewide admin privileges'
  task make_admin: :environment do
    print 'Enter user email: '
    email = $stdin.gets.chomp
    UserManagement.make_site_admin email
  end
end