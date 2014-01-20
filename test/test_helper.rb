require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/focus"
require "minitest/pride"
require "capybara/webkit"

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

end

class ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  include Capybara::DSL
end

# ALBUM UTILITIES

def create_album
  visit new_user_album_path(users(:user2).id)
  fill_in "Title", with: "Example Album 1"
  click_on "Create Album"
end

# SONG UTILITIES

def create_song
  visit new_user_album_song_path(999, 999)
  fill_in "Title", with: "Example Song 1"
  fill_in "The track's mood", with: 1
  fill_in "The track's timbre", with: 1
  fill_in "The track's intensity", with: 1
  fill_in "The track's tone", with: 1
  click_on "Create Song"
end

def create_second_song
  visit new_user_album_song_path(999, 999)
  fill_in "Title", with: "Example Song 2"
  fill_in "The track's mood", with: 99
  fill_in "The track's timbre", with: 99
  fill_in "The track's intensity", with: 99
  fill_in "The track's tone", with: 99
  click_on "Create Song"
end

# PLAYLIST UTILITIES

def create_playlist
  visit new_user_playlist_path(@user = users(:user1).id)
  fill_in "Name", with: "Example Playlist"
  fill_in "Mood", with: 0
  fill_in "Timbre", with: 0
  fill_in "Intensity", with: 0
  fill_in "Tone", with: 0
  choose "playlist_scope_strict"
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
  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "password"
end

def enter_band_credentials
  fill_in "Email", with: "band@example.com"
  fill_in "Password", with: "password"
end

Turn.config.format = :outline
