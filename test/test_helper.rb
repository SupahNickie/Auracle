require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.command_name "MiniTest"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'minitest/pride'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  fixtures :all
end

class ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include Capybara::Assertions
end

# ALBUM UTILITIES

def create_album
  visit new_user_album_path(users(:user2))
  fill_in "Title", with: "Example Created Album 1"
  click_on "Create Album"
end

# SONG UTILITIES

def create_song
  visit new_user_album_song_path(users(:user2), albums(:album1))
  fill_in "Title", with: "Example Created Song 1"
  fill_in "The track's mood", with: 1
  fill_in "The track's timbre", with: 1
  fill_in "The track's intensity", with: 1
  fill_in "The track's tone", with: 1
  click_on "Create Song"
end

def create_second_song
  visit new_user_album_song_path(users(:user2), albums(:album1))
  fill_in "Title", with: "Example Created Song 2"
  fill_in "The track's mood", with: 99
  fill_in "The track's timbre", with: 99
  fill_in "The track's intensity", with: 99
  fill_in "The track's tone", with: 99
  click_on "Create Song"
end

# PLAYLIST UTILITIES

def create_all_songs_playlist
  visit root_path
  click_on "My Playlists"
  click_on "New Playlist"
  fill_in "Name", with: "Example Created Playlist 1"
  fill_in "Mood", with: 0
  fill_in "Timbre", with: 0
  fill_in "Intensity", with: 0
  fill_in "Tone", with: 0
  choose "playlist_scope_strict"
  click_on "Create Playlist"
end

def create_54_scores_playlist
  visit root_path
  click_on "My Playlists"
  click_on "New Playlist"
  fill_in "Name", with: "Example Created Playlist 2"
  fill_in "Mood", with: 54
  fill_in "Timbre", with: 54
  fill_in "Intensity", with: 54
  fill_in "Tone", with: 54
  choose "playlist_scope_loose"
  click_on "Create Playlist"
end

def create_55_scores_playlist
  visit root_path
  click_on "My Playlists"
  click_on "New Playlist"
  fill_in "Name", with: "Example Created Playlist 3"
  fill_in "Mood", with: 55
  fill_in "Timbre", with: 55
  fill_in "Intensity", with: 55
  fill_in "Tone", with: 55
  choose "playlist_scope_expansive"
  click_on "Create Playlist"
end

# LOGIN UTILITIES

def login_personal
  visit new_user_session_path
  enter_credentials
  click_on "Sign in"
end

def login_band
  visit new_user_session_path
  enter_band_credentials
  click_on "Sign in"
end

def enter_credentials
  fill_in "Username", with: "Example User"
  fill_in "Password", with: "password"
end

def enter_band_credentials
  fill_in "Username", with: "Band Example"
  fill_in "Password", with: "password"
end
