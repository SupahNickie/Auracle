require 'test_helper'

feature "Song CRUD" do
  scenario "songs will get uploaded properly" do
    login_band
    create_song
    page.text.must_include "Song was successfully created"
  end

  scenario "loading another song won't break it" do
    login_band
    create_song
    create_second_song
    page.text.must_include "Song was successfully created"
    visit user_album_path(users(:user2), albums(:album1))
    page.text.must_include "Example Song 1"
    page.text.must_include "Example Song 2"
  end

end
