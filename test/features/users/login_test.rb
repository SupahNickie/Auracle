require 'test_helper'

feature "signing up a new user" do
  scenario "new users are signed up properly" do
    visit new_user_registration_path
    fill_in "Username", with: "New User"
    fill_in "Email", with: "new@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    choose "user_role_personal"
    click_on "Sign up"
    page.text.must_include "You have signed up successfully."
  end

  scenario "new bands are signed up properly" do
    visit new_user_registration_path
    fill_in "Username", with: "Awesome Band"
    fill_in "Email", with: "awesomeband@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    choose "user_role_band"
    click_on "Sign up"
    page.text.must_include "You have signed up successfully."
  end
end

feature "using Oauth to sign in" do
  scenario "a visitor can sign in with twitter (will be a personal account)" do
    visit new_user_session_path
    login_twitter_user
    click_on "Sign in with Twitter"
    page.text.must_include "Sign Out"
    page.text.must_include "Signed in as test_twitter_user"
  end

  scenario "a visitor can sign in with google (will be a personal account)" do
    visit new_user_session_path
    login_google_user
    click_on "Sign in with Google Oauth2"
    page.text.must_include "Sign Out"
    page.text.must_include "Signed in as test_google_user"
  end

  scenario "a visitor can sign in with twitter (will be a personal account)" do
    visit new_user_session_path
    login_facebook_user
    click_on "Sign in with Facebook"
    page.text.must_include "Sign Out"
    page.text.must_include "Signed in as test_facebook_user"
  end
end

feature "signing in a registered user" do
  scenario "registered users are signed in properly" do
    login_personal
    page.text.must_include "Sign Out"
    page.text.must_include "Signed in successfully."
  end

  scenario "registered bands are signed in properly" do
    login_band
    page.text.must_include "Sign Out"
    page.text.must_include "Signed in successfully."
  end
end

feature "signing in/up an invalid user" do
  scenario "the login doesn't work" do
    visit new_user_session_path
    fill_in "Username", with: "asdfoin"
    fill_in "Password", with: "qweproiu"
    click_on "Sign in"
    page.text.must_include "Invalid username or password."
  end

  scenario "the signup doesn't work" do
    visit new_user_registration_path
    fill_in "Username", with: ""
    fill_in "Password", with: ""
    click_on "Sign up"
    page.text.must_include "errors prohibited this user from being saved:"
  end
end
