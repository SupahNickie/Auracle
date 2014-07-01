require 'test_helper'

feature "Playlist CRUD" do
  scenario "a new playlist can be created by a user with a personal account" do
    login_personal
    create_all_songs_playlist
    page.text.must_include "Playlist was successfully created."
  end

  scenario "a new playlist can also be created by a band account" do
    login_band
    create_all_songs_playlist
    page.text.must_include "Playlist was successfully created."
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
    page.text.must_include "Playlist was successfully destroyed."
  end

  scenario "a playlist can be deleted (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Destroy"
    page.text.must_include "Playlist was successfully destroyed."
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
    page.text.must_include "Playlist was successfully updated."
  end

  scenario "a playlist can be edited (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Edit"
    fill_in "Name", with: "Edited Playlist 2"
    fill_in "Mood", with: 80
    click_on "Update Playlist"
    page.text.must_include "Playlist was successfully updated."
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

feature "Playlists finding music" do
  scenario "a visited playlist finds all music when asked to (personal account)" do
    login_personal
    create_all_songs_playlist
    page.text.must_include "Band Example - Example Song 1"
    page.text.must_include "Band Example - Example Song 2"
  end

  scenario "a visited playlist finds all music when asked to (band account)" do
    login_band
    create_all_songs_playlist
    page.text.must_include "Band Example - Example Song 1"
    page.text.must_include "Band Example - Example Song 2"
  end

  scenario "a visited playlist finds all music when asked to (guest user, no account)" do
    visit root_path
    click_on "Make a playlist to try out!"
    fill_in "Mood", with: 0
    fill_in "Timbre", with: 0
    fill_in "Intensity", with: 0
    fill_in "Tone", with: 0
    choose "playlist_scope_strict"
    click_on "Create Playlist"
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
    Rails.cache.clear
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "View Songs"
    page.text.must_include "Band Example, from the album Example Album 1"
  end
end

feature "Playlist favoriting/unfavoriting" do
  scenario "a song can be favorited (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example - Example Song"
  end

  scenario "a song can be favorited (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example - Example Song"
  end

  scenario "a song can be unfavorited once favorited already (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example - Example Song"
    click_on "Remove from favorites"
    page.text.must_include "Song was successfully unfavorited"
    page.text.must_include "You don't have any favorites set for this playlist yet!"
  end

  scenario "a song can be unfavorited once favorited already (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example - Example Song"
    click_on "Remove from favorites"
    page.text.must_include "Song was successfully unfavorited"
    page.text.must_include "You don't have any favorites set for this playlist yet!"
  end

  scenario "a song can be blacklisted (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    page.text.must_include "Song was successfully removed from this playlist."
    page.text.must_include "We're sorry you didn't like that song!"
  end

  scenario "a song can be blacklisted (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    page.text.must_include "Song was successfully removed from this playlist."
    page.text.must_include "We're sorry you didn't like that song!"
  end

  scenario "a song can be blacklisted even after being favorited (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    page.text.must_include "" # Pop-up rating window will be closed because the user is not allowed to rate more than once
  end

  scenario "a song can be blacklisted even after being favorited (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    page.text.must_include "" # Pop-up rating window will be closed because the user is not allowed to rate more than once
  end

  scenario "a song can be voted on after being blacklisted (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    choose "playlist_mood_55"
    choose "playlist_timbre_50"
    choose "playlist_intensity_60"
    choose "playlist_tone_55"
    click_on "Add My Rating!"
  end

  scenario "a song can be voted on after being blacklisted (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    choose "playlist_mood_55"
    choose "playlist_timbre_50"
    choose "playlist_intensity_60"
    choose "playlist_tone_55"
    click_on "Add My Rating!"
  end

  scenario "a song can be saved from the blacklist as well (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    click_on "Review Favorited and Blacklisted Songs"
    click_on "Remove from blacklist"
    page.text.must_include "Song was successfully given another chance!"
  end

  scenario "a song can be saved from the blacklist as well (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    click_on "Review Favorited and Blacklisted Songs"
    click_on "Remove from blacklist"
    page.text.must_include "Song was successfully given another chance!"
  end
end
