require 'test_helper'

feature "Auracle explanation on about page" do
  scenario "the about page explains a bit about Auracle" do
    visit "/about"
    page.text.must_include "A new kind of app that'll tear your face off of your face"
  end
end
