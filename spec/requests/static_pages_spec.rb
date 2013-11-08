require 'spec_helper'

describe "Static Pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Proton' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('Home - ') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Proton' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'Proton' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path

    first(:link, 'Help').click
    expect(page).to have_title(full_title('Help'))

    within(:xpath, '//footer[@class="footer"]') do
      click_link 'Help'
      expect(page).to have_title(full_title('Help'))
    end

    click_link 'About'
    expect(page).to have_title(full_title('About'))
  end
end
