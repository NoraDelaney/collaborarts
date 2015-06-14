require 'spec_helper'

describe "User submits info" #  :type => :feature do

  scenario "user submits their name" do
    visit '/form'
    fill_in 'First name', with: 'Ben'
    click_button 'Submit'

    expect(page).to have_content("You've found a match")
end
