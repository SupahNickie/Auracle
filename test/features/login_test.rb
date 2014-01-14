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
end

feature "signing in a registered user" do
  scenario "registered users are signed in properly" do
    visit new_user_session_path
    enter_credentials
    click_on "Sign in"
    page.text.must_include "Signed in successfully."
  end

  scenario "registered bands are signed in properly" do
    visit new_user_session_path
    enter_band_credentials
    click_on "Sign in"
    page.text.must_include "Signed in successfully."
  end
end

