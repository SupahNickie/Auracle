require 'test_helper'

feature "Playlist CRUD" do
  scenario "a new playlist gets created in the first place" do
    login_personal
    create_playlist
    page.text.must_include "Playlist was successfully created."
  end

  scenario "a faulty playlist doesn't get created" do
    # pending "Tests will pass when validations are implemented"
  end

  scenario "a visited playlist looks for music" do
    # pending "Test will pass when songs are loaded"
    # login_personal
    # create_playlist
    # click_on "Show"
    # page.text.must_include "Example Playlist"
  end
end
