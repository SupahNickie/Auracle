require "test_helper"

feature "default rake minitest works and can access home" do
  scenario "everything will work just fine" do
    visit root_path
    page.must_have_content "Auracle"
  end
end
