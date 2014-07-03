require 'test_helper'

feature "Song CRUD" do
  scenario "songs will get uploaded properly" do
    login_band
    create_song
    page.text.must_include "Song was successfully created!"
  end

  scenario "loading another song won't break it" do
    login_band
    create_song
    create_second_song
    page.text.must_include "Song was successfully created!"
    visit user_album_path(users(:user2), albums(:album1))
    page.text.must_include "Example Created Song 1"
    page.text.must_include "Example Created Song 2"
  end

  scenario "uploading a faulty song won't work" do
    login_band
    visit new_user_album_song_path(users(:user2), albums(:album1))
    click_on "Create Song"
    page.text.must_include "6 errors prohibited"
  end

  scenario "trying to add a song to another band's album fails" do
    login_band
    visit user_album_path(users(:user3), albums(:album2))
    page.wont_have_content "Add New Song to Album"
    visit new_user_album_song_path(users(:user3), albums(:album2))
    page.text.must_include "only the admin"
  end

  scenario "trying to somehow load a song as a personal account fails" do
    login_personal
    visit user_album_path(users(:user2), albums(:album1))
    page.wont_have_content "Add New Song to Album"
    visit new_user_album_song_path(users(:user3), albums(:album2))
    page.text.must_include "only the admin"
  end

  scenario "editing a song (as a band) succeeds" do
    login_band
    visit edit_user_album_song_path(users(:user2), albums(:album1), songs(:song1))
    fill_in "Title", with: "Updated Song Title"
    click_on "Update Song"
    page.text.must_include "Song was successfully updated!"
    page.text.must_include "Updated Song Title"
  end

  scenario "editing another band's song (as a band) fails" do
    login_band
    visit edit_user_album_song_path(users(:user3), albums(:album2), songs(:song3))
    page.text.must_include "only the admin"
    page.wont_have_content "Title"
    page.wont_have_content "Link to purchase" # Won't render the form for updating a song
  end

  scenario "editing any band's song (as a personal account) fails" do
    login_personal
    visit edit_user_album_song_path(users(:user2), albums(:album1), songs(:song2))
    page.text.must_include "only the admin"
    page.wont_have_content "Title"
    page.wont_have_content "Link to purchase" # Won't render the form for updating a song
  end

  scenario "deleting a song (as a band) succeeds" do
    login_band
    visit user_album_path(users(:user2), albums(:album1))
    click_on "Delete Example Song 2"
    page.text.must_include "Song was successfully deleted!"
    page.wont_have_content "Example Song 2"
  end

  scenario "deleting another band's song (as a band) fails" do
    login_band
    visit user_album_path(users(:user3), albums(:album2))
    page.wont_have_content "Delete Example Song 3"
    page.text.must_include "Example Song 3"
  end

  scenario "deleting any band's song (as a personal account) fails" do
    login_personal
    visit user_album_path(users(:user2), albums(:album1))
    page.wont_have_content "Delete Example Song 1"
    page.text.must_include "Example Song 1"
  end
end
