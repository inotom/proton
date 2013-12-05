require 'spec_helper'

describe "Work pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "work creation" do
    before { visit new_work_path }

    it { should have_content('Create work') }
    it { should have_title(full_title('Create work')) }

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
        before { click_button "Create work" }
        it { should have_content('Work created!') }
        it { should have_content(user.name) }
      end
    end
  end
end
