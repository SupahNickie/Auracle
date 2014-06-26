namespace :clear_guests do
  desc "gets rid of guest users"
  task :get_rid_of_them => :environment do
    User.where("encrypted_password = ''").where("username = 'Guest'").where("email LIKE '%example.com%'").map(&:destroy)
  end
end
