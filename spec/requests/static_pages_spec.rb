require 'spec_helper'

describe "Static Pages" do

  describe "Home page" do

    it "should have the content 'Proton'" do
      visit '/static_pages/home'
      expect(page).to have_content('Proton')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end

  describe "About page" do

    it "should have the content 'About Proton'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Proton')
    end
  end
end
