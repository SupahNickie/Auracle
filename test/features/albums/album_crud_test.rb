require 'test_helper'

feature "Album CRUD" do
  scenario "creating a new album (as a band) succeeds" do
    login_band
    create_album
    page.text.must_include "Album was successfully created!"
  end

  scenario "creating a new album (as a personal account) fails" do
    login_personal
    visit new_user_album_path(users(:user1))
    page.text.must_include "only the admin"
  end

  scenario "editing an album (as a band) succeeds" do
    login_band
    visit user_album_path(users(:user2), albums(:album1))
    click_on "Edit Album Details"
    fill_in "Title", with: "Changed Album Title"
    click_on "Update Album"
    page.text.must_include "Changed Album Title"
    page.text.must_include "Album was successfully updated!"
  end

  scenario "editing another user's album (as a band) fails" do
    login_band
    visit user_album_path(users(:user3), albums(:album2))
    click_on "Edit Album Details"
    page.text.must_include "only the admin"
    page.wont_have_content "Title"
  end

  scenario "editing another user's album (as a personal account) fails" do
    login_personal
    visit user_album_path(users(:user3), albums(:album2))
    click_on "Edit Album Details"
    page.text.must_include "only the admin"
    page.wont_have_content "Title"
  end

  scenario "deleting an album (as a band) succeeds" do
    login_band
    visit user_albums_path(users(:user2))
    click_on "Destroy"
    page.text.must_include "Album was successfully deleted!"
    page.wont_have_content "Destroy"
    page.wont_have_content "Example Album 1"
  end

  scenario "deleting another band's album (as a band account) fails" do
    login_band
    visit user_albums_path(users(:user3))
    click_on "Destroy"
    page.text.must_include "only the admin"
    visit user_albums_path(users(:user3))
    page.text.must_include "Example Album 2"
  end

  scenario "deleting any band's album (as a personal account) fails" do
    login_personal
    visit user_albums_path(users(:user2))
    click_on "Destroy"
    page.text.must_include "only the admin"
    visit user_albums_path(users(:user3))
    page.text.must_include "Example Album 2"
  end
end
