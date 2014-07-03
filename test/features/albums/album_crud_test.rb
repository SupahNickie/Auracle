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
    page.text.must_include "Sorry, you cannot"
  end

  scenario "a faulty album will not get saved" do
    login_band
    visit new_user_album_path(users(:user2))
    click_on "Create Album"
    page.text.must_include "2 errors prohibited"
  end

  scenario "editing an album (as a band) succeeds" do
    login_band
    visit user_album_path(users(:user2), albums(:album1))
    click_on "Edit Album Details"
    fill_in "Title", with: "Changed Album Title"
    attach_file("Album art", 'test/fixtures/files/sample_picture.jpg')
    click_on "Update Album"
    page.text.must_include "Changed Album Title"
    page.text.must_include "Album was successfully updated!"
  end

  scenario "editing another user's album (as a band) fails" do
    login_band
    visit user_album_path(users(:user3), albums(:album2))
    page.wont_have_content "Edit Album Details"
    visit edit_user_album_path(users(:user3), albums(:album2))
    page.text.must_include "Sorry, you cannot"
    page.wont_have_content "Title"
  end

  scenario "editing another user's album (as a personal account) fails" do
    login_personal
    visit user_album_path(users(:user3), albums(:album2))
    page.wont_have_content "Edit Album Details"
    visit edit_user_album_path(users(:user3), albums(:album2))
    page.text.must_include "Sorry, you cannot"
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
    page.wont_have_content "Destroy"
    page.text.must_include "Example Album 2"
  end

  scenario "deleting any band's album (as a personal account) fails" do
    login_personal
    visit user_albums_path(users(:user2))
    page.wont_have_content "Destroy"
    page.text.must_include "Example Album 1"
  end
end
