require 'test_helper'

feature "Playlist favoriting/unfavoriting" do
  scenario "a song can be favorited (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example"
    page.text.must_include "Example Song"
  end

  scenario "a song can be favorited (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example"
    page.text.must_include "Example Song"
  end

  scenario "a song can be unfavorited once favorited already (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example"
    page.text.must_include "Example Song"
    click_on "Remove from favorites"
    page.text.must_include "Song was successfully unfavorited!"
    page.text.must_include "You don't have any favorites set for this playlist yet!"
  end

  scenario "a song can be unfavorited once favorited already (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[0].click
    page.text.must_include "Song was successfully favorited to this playlist!"
    page.text.must_include "Band Example"
    page.text.must_include "Example Song"
    click_on "Remove from favorites"
    page.text.must_include "Song was successfully unfavorited!"
    page.text.must_include "You don't have any favorites set for this playlist yet!"
  end

  scenario "a song can be blacklisted (personal account)" do
    login_personal
    visit root_path
    click_on "My Playlists"
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    page.text.must_include "Song was successfully removed from this playlist!"
    page.text.must_include "We're sorry you didn't like that song!"
  end

  scenario "a song can be blacklisted (band account)" do
    login_band
    visit user_playlists_path(users(:user2))
    click_on "Play"
    favorite_links = page.all(".glyphicons")
    favorite_links[1].click
    page.text.must_include "Song was successfully removed from this playlist!"
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
    favorite_links[0].click # The first link, which would have been the one to favorite it, is disabled once a song is favorited
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
