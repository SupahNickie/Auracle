require 'test_helper'

feature "Album CRUD" do
  scenario "creating a new album (as a band) succeeds" do
    login_band
    create_album
    page.text.must_include "Album was successfully created"
  end

  scenario "creating a new album (as a personal account) fails" do
    login_personal
    visit new_user_album_path(users(:user1).id)
    page.text.must_include "only the admin"
  end
end
