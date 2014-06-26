namespace :clear_guests do
  desc "gets rid of guest users"
  task :get_rid_of_them => :environment do
    dead_users = User.where("encrypted_password = ''").where("username = 'Guest'").where("email LIKE '%example.com%'")
    Playlist.where("user_id IN (?)", dead_users.pluck(:id)).map(&:destroy)
    dead_users.map(&:destroy)
  end
end
