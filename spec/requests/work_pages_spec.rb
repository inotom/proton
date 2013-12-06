require 'spec_helper'

describe "Work pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "work creation" do
    before { visit new_work_path }

    it { should have_content('Create work') }
    it { should have_title(full_title('Create work')) }
    it { should have_link('Back', root_path) }

    describe "with invalid information" do

      it "should not create a work" do
        expect { click_button 'Create work' }.not_to change(Work, :count)
      end

      describe "error messages" do
        before do
          fill_in 'work_title', with: ''
          click_button 'Create work'
        end
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in 'work_title', with: 'New Work'
      end
      it "should create a work" do
        expect { click_button "Create work" }.to change(Work, :count).by(1)
      end

      describe "success message" do
        before do
          fill_in 'work_title', with: 'New work Title'
          click_button "Create work"
        end
        it { should have_content('Work created!') }
        it { should have_content(user.name) }
        it { should have_content('New work Title') }
      end
    end
  end

  describe "work show" do
    let(:work) { FactoryGirl.create(:work,
                                    user: user,
                                    title: 'Work Name',
                                    payment: 1500.0,
                                    other: 'Lorem Ipsum',
                                    claimed: true,
                                    receipted: false,
                                    finished: false) }

    describe "page" do
      before { visit work_path(work) }
      it { should have_title(work.title) }
      it { should have_content(work.title) }
      it { should have_content(work.payment) }
      it { should have_content(work.other) }
      it { should have_selector("span.status-claimed-done") }
      it { should have_selector("span.status-receipted-progress") }
      it { should have_selector("span.status-finished-progress") }
      it { should have_link('Back', root_path) }
      it { should have_link('Edit', edit_work_path(work)) }
      it { should have_link('Delete') }
    end
  end

  describe "work edit" do
    let(:work) { FactoryGirl.create(:work, user: user) }

    describe "page" do
      before { visit edit_work_path(work) }
      it { should have_title("Edit work") }
      it { should have_button("Update work") }
      it { should have_link('Back', work_path(work)) }

      describe "with invalid information" do
        before do
          visit edit_work_path(work)
          fill_in 'work_title', with: ''
          click_button 'Update work'
        end
        it { should have_content('error') }
      end

      describe "with valid information" do
        before do
          visit edit_work_path(work)
          fill_in 'work_title', with: 'Updated work title'
        end
        it "should not change work count" do
          expect { click_button 'Update work' }.to change(Work, :count).by(0)
        end

        describe "success update" do
          before { click_button 'Update work' }
          it { should have_content('Work updated!') }
          it { should have_content('Updated work title') }
        end
      end
    end
  end

  describe "work delete" do
    let(:work) { FactoryGirl.create(:work, user: user) }

    describe "page" do
      before { visit work_path(work) }

      it "should delete a work" do
        expect { click_link 'Delete' }.to change(Work, :count).by(-1)
      end
    end

  end
end
