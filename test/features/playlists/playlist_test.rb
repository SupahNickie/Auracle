require 'test_helper'

feature "Playlist CRUD" do
  scenario "a new playlist gets created in the first place" do
    login_personal
    create_all_songs_playlist
    page.text.must_include "Playlist was successfully created."
  end

  scenario "a faulty playlist doesn't get created" do
    # pending "Tests will pass when validations are implemented"
  end

  scenario "a visited playlist finds all music when asked to" do
    login_personal
    create_all_songs_playlist
    page.text.must_include "Band Example - Example Song 1"
    page.text.must_include "Band Example - Example Song 2"
  end

  scenario "a playlist with defined scores of 54 and a mid scope will not find the second song" do
    login_personal
    create_54_scores_playlist
    page.text.must_include "Band Example - Example Song 1"
    page.text.wont_include "Band Example - Example Song 2"
  end

  scenario "a playlist with defined scores of 55 and an expansive scope will find both songs" do
    login_personal
    create_55_scores_playlist
    page.text.must_include "Band Example - Example Song 1"
    page.text.must_include "Band Example - Example Song 2"
  end

  scenario "a playlist can be viewed without playing music first (even though it still queries the database)" do
    login_personal
    visit user_playlists_path(users(:user1))
    click_on "Play"
    page.text.must_include "Band Example - Example Song 1"
    page.text.must_include "Band Example - Example Song 2"
  end
end
