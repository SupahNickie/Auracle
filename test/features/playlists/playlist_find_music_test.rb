require 'test_helper'

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
