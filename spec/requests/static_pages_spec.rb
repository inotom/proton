require 'spec_helper'

describe "Static Pages" do

  let(:base_title) { "Proton" }

  describe "Home page" do

    it "should have the h1 'Proton'" do
      visit root_path
      expect(page).to have_content('Proton')
    end

    it "should have the base title" do
      visit root_path
      expect(page).to have_title("#{base_title}")
    end

    it "should not have a custom page title" do
      visit root_path
      expect(page).not_to have_title('HOME - ')
    end
  end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit help_path
      expect(page).to have_content('Help')
    end

    it "should have the right title" do
      visit help_path
      expect(page).to have_title("Help - #{base_title}")
    end
  end

  describe "About page" do

    it "should have the h1 'About Proton'" do
      visit about_path
      expect(page).to have_content('About Proton')
    end

    it "should have the right title" do
      visit about_path
      expect(page).to have_title("About - #{base_title}")
    end
  end
end
