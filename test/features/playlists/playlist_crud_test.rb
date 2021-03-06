require 'test_helper'

feature "Playlist CRUD" do
  scenario "a new playlist can be created by a user with a personal account" do
    login_personal
    create_55_scores_playlist
    page.text.must_include "Playlist was successfully created!"
  end

  scenario "a new playlist can also be created by a band account" do
    login_band
    create_55_scores_playlist
    page.text.must_include "Playlist was successfully created!"
  end

  scenario "a guest user can even create a playlist" do
    visit playlists_try_path
    page.all("#playlist_mood").first.set 55
    page.all("#playlist_timbre").first.set 55
    page.all("#playlist_intensity").first.set 55
    page.all("#playlist_tone").first.set 55
    choose "playlist_scope_strict"
    click_on "Create Playlist"
    page.text.must_include "We hope you enjoy trying Auracle!"
  end

  scenario "a faulty playlist doesn't get created" do
    login_band
    visit new_user_playlist_path(users(:user2))
    click_on "Create Playlist"
    page.text.must_include "6 errors prohibited"
  end

  scenario "a playlist can be marked as private" do
    login_personal
    visit edit_user_playlist_path(users(:user1), playlists(:playlist1))
    fill_in "Name", with: "Private!"
    page.find('#playlist_invisible').set true
    click_on "Update Playlist"
    page.text.must_include "Playlist was successfully updated!"
    click_on "Sign Out"
    login_band
    visit user_playlists_path(users(:user1))
    page.wont_have_content "Private!"
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
    page.all("#playlist_mood").first.set 80
    click_on "Update Playlist"
    page.text.must_include "Playlist was successfully updated!"
  end

  scenario "a playlist can be edited (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Edit"
    fill_in "Name", with: "Edited Playlist 2"
    page.all("#playlist_mood").first.set 80
    click_on "Update Playlist"
    page.text.must_include "Playlist was successfully updated!"
  end

  scenario "a playlist can NOT be edited by a guest" do
    visit root_path
    click_on "Make a playlist to try out!"
    page.all("#playlist_mood").first.set 55
    page.all("#playlist_timbre").first.set 55
    page.all("#playlist_intensity").first.set 55
    page.all("#playlist_tone").first.set 55
    choose "playlist_scope_strict"
    click_on "Create Playlist"
    visit "/users/#{User.last.to_param}/playlists"
    page.text.must_include "Sorry, that last request either didn't work out or you don't have permission to do that."
  end
end
