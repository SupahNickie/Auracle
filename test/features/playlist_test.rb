require 'test_helper'

feature "creating playlists" do
  scenario "a new playlist gets created in the first place" do
    login_personal
    create_playlist
    page.text.must_include "Playlist was successfully created."
  end

  scenario "a faulty playlist doesn't get created" do
    pending
  end

  scenario "a visited playlist looks for music" do
    login_personal
    create_playlist
    click_on "Show"
    page.text.must_include "Example Playlist"
  end
end
