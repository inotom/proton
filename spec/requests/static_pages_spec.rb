require 'spec_helper'

describe "Static Pages" do

  let(:base_title) { "Proton" }

  describe "Home page" do

    it "should have the content 'Proton'" do
      visit '/static_pages/home'
      expect(page).to have_content('Proton')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("Home - #{base_title}")
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("Help - #{base_title}")
    end
  end

  describe "About page" do

    it "should have the content 'About Proton'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Proton')
    end

    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("About - #{base_title}")
    end
  end
end
