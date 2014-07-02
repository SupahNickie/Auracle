require 'test_helper'

feature "Playlist CRUD" do
  scenario "a new playlist can be created by a user with a personal account" do
    login_personal
    create_all_songs_playlist
    page.text.must_include "Playlist was successfully created!"
  end

  scenario "a new playlist can also be created by a band account" do
    login_band
    create_all_songs_playlist
    page.text.must_include "Playlist was successfully created!"
  end

  scenario "a guest user can even create a playlist" do
    visit playlists_try_path
    fill_in "Mood", with: 0
    fill_in "Timbre", with: 0
    fill_in "Intensity", with: 0
    fill_in "Tone", with: 0
    choose "playlist_scope_strict"
    click_on "Create Playlist"
    page.text.must_include "We hope you enjoy trying Auracle!"
  end

  scenario "a faulty playlist doesn't get created" do
    # pending "Tests will pass when validations are implemented"
  end

  scenario "a playlist can be deleted (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Destroy"
    page.text.must_include "Playlist was successfully deleted!"
  end

  scenario "a playlist can be deleted (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Destroy"
    page.text.must_include "Playlist was successfully deleted!"
  end

  scenario "a playlist can NOT be deleted by a guest" do
    visit user_playlists_path(users(:user2))
    page.text.must_include "Sorry, that last request either didn't work out or you don't have permission to do that."
  end

  scenario "a playlist can be edited (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Edit"
    fill_in "Name", with: "Edited Playlist 1"
    fill_in "Mood", with: 80
    click_on "Update Playlist"
    page.text.must_include "Playlist was successfully updated!"
  end

  scenario "a playlist can be edited (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Edit"
    fill_in "Name", with: "Edited Playlist 2"
    fill_in "Mood", with: 80
    click_on "Update Playlist"
    page.text.must_include "Playlist was successfully updated!"
  end

  scenario "a playlist can NOT be edited by a guest" do
    visit root_path
    click_on "Make a playlist to try out!"
    fill_in "Mood", with: 0
    fill_in "Timbre", with: 0
    fill_in "Intensity", with: 0
    fill_in "Tone", with: 0
    choose "playlist_scope_strict"
    click_on "Create Playlist"
    visit "/users/#{User.last.to_param}/playlists"
    page.text.must_include "Sorry, that last request either didn't work out or you don't have permission to do that."
  end
end
