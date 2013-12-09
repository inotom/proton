require 'spec_helper'

describe "Worktime Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:work, user: user, title: 'New Work') }

  before { sign_in user }

  describe "work page" do
    before { visit work_path(work) }

    it { should have_button('Start work') }
    it { should_not have_button('End work') }

    describe "worktime creation" do
      it "should create a worktime" do
        expect { click_button 'Start work' }.to change(Worktime, :count).by(1)
      end

      before { click_button 'Start work' }
      it { should have_content('Start work!') }
    end

  end
end
