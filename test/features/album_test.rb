require 'test_helper'

feature "Album CRUD" do
  scenario "creating a new album (as a band) succeeds" do
    login_band
    create_album
    page.text.must_include "Album was successfully created"
  end

  scenario "creating a new album (as a personal account) fails" do
    pending "Test will pass when Pundit is installed properly"
    # login_personal
    # visit new_user_album_path(users(:user1).id)
    # fill_in "Title", with: "Example Album Shouldn't Work?"
    # click_on "Create Album"
    # page.text.must_include "not permitted"
  end
end
