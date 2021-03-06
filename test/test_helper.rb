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
  attach_file("Album art", 'test/fixtures/files/sample_picture.jpg')
  click_on "Create Album"
end

# SONG UTILITIES

def create_song
  visit new_user_album_song_path(users(:user2), albums(:album1))
  fill_in "Title", with: "Example Created Song 1"
  attach_file("Mp3", 'test/fixtures/files/sample_song.mp3')
  page.find("#song_mood").set 1
  page.find("#song_timbre").set 1
  page.find("#song_intensity").set 1
  page.find("#song_tone").set 1
  click_on "Create Song"
end

def create_second_song
  visit new_user_album_song_path(users(:user2), albums(:album1))
  fill_in "Title", with: "Example Created Song 2"
  attach_file("Mp3", 'test/fixtures/files/sample_song.mp3')
  page.find("#song_mood").set 99
  page.find("#song_timbre").set 99
  page.find("#song_intensity").set 99
  page.find("#song_tone").set 99
  click_on "Create Song"
end

# PLAYLIST UTILITIES

def create_54_scores_playlist
  visit root_path
  click_on "My Playlists"
  click_on "New Playlist"
  fill_in "Name", with: "Example Created Playlist 2"
  page.all("#playlist_mood").first.set 54
  page.all("#playlist_timbre").first.set 54
  page.all("#playlist_intensity").first.set 54
  page.all("#playlist_tone").first.set 54
  choose "playlist_scope_loose"
  click_on "Create Playlist"
end

def create_55_scores_playlist
  visit root_path
  click_on "My Playlists"
  click_on "New Playlist"
  fill_in "Name", with: "Example Created Playlist 3"
  page.all("#playlist_mood").first.set 55
  page.all("#playlist_timbre").first.set 55
  page.all("#playlist_intensity").first.set 55
  page.all("#playlist_tone").first.set 55
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

def login_twitter_user
  OmniAuth.config.test_mode = true
  Capybara.current_session.driver.request.env['devise.mapping'] = Devise.mappings[:user]
  Capybara.current_session.driver.request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
  OmniAuth.config.add_mock(:twitter, { uid: '12345', info: { nickname: 'test_twitter_user' } })
end

def login_facebook_user
  OmniAuth.config.test_mode = true
  Capybara.current_session.driver.request.env['devise.mapping'] = Devise.mappings[:user]
  Capybara.current_session.driver.request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
  OmniAuth.config.add_mock(:facebook, { uid: '12345', info: { nickname: 'test_facebook_user' } })
end

def login_google_user
  OmniAuth.config.test_mode = true
  Capybara.current_session.driver.request.env['devise.mapping'] = Devise.mappings[:user]
  Capybara.current_session.driver.request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  OmniAuth.config.add_mock(:google_oauth2, { uid: '12345', info: { name: 'test_google_user', email: "go_away@example.com" } })
end

def enter_credentials
  fill_in "Username", with: "Example User"
  fill_in "Password", with: "password"
end

def enter_band_credentials
  fill_in "Username", with: "Band Example"
  fill_in "Password", with: "password"
end
