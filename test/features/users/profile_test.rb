require 'test_helper'

feature "Editing a user profile" do
  scenario "a user can update their own profile" do
    login_personal
    click_on "Example User's Profile"
    click_on "Edit Profile"
    attach_file("Avatar", 'test/fixtures/files/sample_picture.jpg')
    click_on "Update Profile"
    page.text.must_include "Your profile was successfully updated!"
  end

  scenario "a band can also update their own profile" do
    login_band
    click_on "Band Example's Artist Profile"
    click_on "Edit Artist Profile"
    attach_file("Avatar", 'test/fixtures/files/sample_picture.jpg')
    click_on "Update Profile"
    page.text.must_include "Your artist profile was successfully updated!"
  end

  scenario "anyone else cannot edit someone else's profile" do
    login_personal
    visit user_path(users(:user2))
    page.wont_have_content "Edit Artist Profile"
    visit edit_user_path(users(:user2))
    page.text.must_include "Sorry, you cannot"
    page.wont_have_content "Avatar"
  end

  scenario "a band also cannot edit a normal user's profile" do
    login_band
    visit profile_user_path(users(:user1))
    page.wont_have_content "Edit Profile"
    visit edit_profile_user_path(users(:user1))
    page.text.must_include "Sorry, you cannot"
    page.wont_have_content "Avatar"
  end
end
