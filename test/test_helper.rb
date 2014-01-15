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
