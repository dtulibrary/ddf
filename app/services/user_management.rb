class UserManagement
  def self.make_site_admin(email)
    user = User.find_by(email: email)
    if user.nil?
      puts "User with email #{email} could not be found!"
      return
    end
    user.roles.build role: 'admin', resource: Spotlight::Site.instance
    user.save
    puts "User #{email} has now been given sitewide admin privileges."
  end
end