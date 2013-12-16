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
    it { should_not have_link('Orderers', orderers_path) }

    describe "sign in" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:work1) { FactoryGirl.create(:work, user: user, title: 'New Work1') }
      let!(:work2) { FactoryGirl.create(:work, user: user, title: 'New Work2') }

      before do
        sign_in user
        visit root_path
      end

      describe "works" do
        it { should have_content(work1.title) }
        it { should have_content(work2.title) }
        it { should have_content(user.works.count) }
        it { should have_link('Create work', href: new_work_path) }
        it { should have_link('Orderers', orderers_path) }
        it { should have_selector('input#search_form_q') }
        it { should have_button('Search') }
        it { should_not have_content('Todo:') }

        describe "search" do
          before do
            fill_in 'search_form_q', with: 'New Work1'
            click_button 'Search'
          end

          it { should have_content(work1.title) }
          it { should_not have_content(work2.title) }

          describe "no matches" do
            before do
              fill_in 'search_form_q', with: 'New Work3'
              click_button 'Search'
            end

            it { should have_content('Works 0') }
            it { should_not have_content(work1.title) }
            it { should_not have_content(work2.title) }
            it { should have_selector('input#search_form_q') }
            it { should have_button('Search') }
          end
        end

        describe 'create a todo' do
          let!(:todo) { FactoryGirl.create(:todo, work: work1, title: 'New Todo') }
          before { visit root_path }
          it { should have_content('Todo: 1') }
        end
      end
    end
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
