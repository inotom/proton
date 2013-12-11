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
    it { should_not have_selector('.worktime-edit a') }
    it { should_not have_selector('.worktime-delete a') }

    describe "worktime creation" do
      it "should create a worktime" do
        expect { click_button 'Start work' }.to change(Worktime, :count).by(1)
      end

      before { click_button 'Start work' }
      it { should have_content('Start work!') }
      it { should have_button('End work') }
      it { should have_selector('.worktime-edit a') }
      it { should have_selector('.worktime-delete a') }

      describe "worktime update (End work)" do
        it "should not create a worktime" do
          expect { click_button 'End work' }.to change(Worktime, :count).by(0)
        end

        describe "should create a end_time" do
          before { click_button 'End work' }
          it { should_not have_button('End work') }
        end
      end
    end
  end

  describe "edit page" do
    let(:worktime) { FactoryGirl.create(:worktime, work: work) }
    before { visit edit_worktime_path(worktime) }

    it { should have_link('Back', work_path(work)) }
    it { should have_title('Edit worktime') }
    it { should have_content('Edit worktime') }
  end

  describe "worktime destruction" do
    before { FactoryGirl.create(:worktime, work: work) }

    describe "as correct user" do
      before { visit work_path(work) }

      it { should have_selector('.worktime-delete a') }

      it "should delete a worktime" do
        expect { find('.worktime-delete').click_link "Delete" }.to change(Worktime, :count).by(-1)
      end
    end
  end
end
