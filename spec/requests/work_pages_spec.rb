require 'spec_helper'

describe "Work pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "work creation" do
    let!(:o1) { FactoryGirl.create(:orderer, user: user, name: 'Orderer1') }
    let!(:o2) { FactoryGirl.create(:orderer, user: user, name: 'Orderer2') }
    before { visit new_work_path }

    it { should have_content('Create work') }
    it { should have_title(full_title('Create work')) }
    it { should have_link('Back', root_path) }
    it { should have_selector("select#work_orderer_id > option",
                              count: user.orderers.size + 1) }

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
        it { should have_selector("select#work_orderer_id > option",
                                  count: user.orderers.size + 1) }
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

      describe "orderers select field" do
        let!(:o1) { FactoryGirl.create(:orderer, user: user, name: 'Orderer1') }
        let!(:o2) { FactoryGirl.create(:orderer, user: user, name: 'Orderer2') }

        before { visit new_work_path }

        it { should have_selector("select#work_orderer_id > option",
                                  count: user.orderers.size + 1) }

        describe "select orderer" do
          before do
            fill_in 'work_title', with: 'New work title'
            select "Orderer1", from: 'work[orderer_id]'
            click_button 'Create work'
          end

          it { should have_selector("span.orderer.orderer-" + (o1.id % 5).to_s) }

          it "should have orderer name in works index page" do
            expect(page).to have_content('Orderer1')
          end

          describe "in work show page" do
            before { click_link 'New work title' }

            it { should have_selector("span.orderer.orderer-" + (o1.id % 5).to_s) }

            it "should have orderer name in work show page" do
              expect(page).to have_content('Orderer1')
            end
          end
        end
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
    let!(:wt1) { FactoryGirl.create(:worktime,
                                    start_time: 1.minute.ago,
                                    work: work) }
    let!(:wt2) { FactoryGirl.create(:worktime,
                                    work: work) }
    let!(:todo) { FactoryGirl.create(:todo, work: work, title: 'New Todo') }

    describe "page" do
      before { visit work_path(work) }
      it { should have_title(work.title) }
      it { should have_content(work.title) }
      it { should have_content(
        ActiveSupport::NumberHelper.number_to_currency(work.payment,
                                                       lacale: 'en')) }
      it { should have_content(work.other) }
      it { should have_selector("span.status-claimed-done") }
      it { should have_selector("span.status-receipted-progress") }
      it { should have_selector("span.status-finished-progress") }
      it { should have_link('Back', root_path) }
      it { should have_link('Edit', edit_work_path(work)) }
      it { should have_link('Delete') }

      describe "worktimes" do
        it { should have_content(worktime_fmt(wt1.start_time)) }
        it { should have_content(worktime_fmt(wt2.start_time)) }
      end

      describe "todos" do
        it { should have_content(todo.title) }
      end
    end
  end

  describe "work edit" do
    let(:work) { FactoryGirl.create(:work, user: user) }
    let!(:o1) { FactoryGirl.create(:orderer, user: user, name: 'Orderer1') }
    let!(:o2) { FactoryGirl.create(:orderer, user: user, name: 'Orderer2') }



    describe "page" do
      before { visit edit_work_path(work) }
      it { should have_title("Edit work") }
      it { should have_button("Update work") }
      it { should have_link('Back', work_path(work)) }
      it { should have_selector("select#work_orderer_id > option",
                                count: user.orderers.size + 1) }

      it "should not finished" do
        expect(work.finished_at).to be_nil
      end

      describe "with invalid information" do
        before do
          visit edit_work_path(work)
          fill_in 'work_title', with: ''
          click_button 'Update work'
        end
        it { should have_content('error') }
        it { should have_selector("select#work_orderer_id > option",
                                  count: user.orderers.size + 1) }
      end

      describe "with valid information" do
        before do
          visit edit_work_path(work)
          find(:css, "#work_finished").set(false)
          fill_in 'work_title', with: 'Updated work title'
        end
        it "should not change work count" do
          expect { click_button 'Update work' }.to change(Work, :count).by(0)
        end

        describe "success update" do
          before { click_button 'Update work' }
          it { should have_content('Work updated!') }
          it { should have_content('Updated work title') }
          it "should not finished" do
            expect(Work.where(id: work.id).first.finished_at).to be_nil
          end
        end
      end

      describe "finished check" do
        before do
          visit edit_work_path(work)
          find(:css, "#work_finished").set(true)
          # check('work_finished')
        end

        describe "work status to be finished" do
          before { click_button 'Update work' }

          it { should have_selector(".status-finished-done") }
          it "should finished" do
            p Work.where(id: work.id).first
            expect(Work.where(id: work.id).first.finished_at).not_to be_nil
          end
        end
      end

      describe "orderers select field" do
        let!(:o1) { FactoryGirl.create(:orderer, user: user, name: 'Orderer1') }
        let!(:o2) { FactoryGirl.create(:orderer, user: user, name: 'Orderer2') }
        before { visit edit_work_path(work) }

        it { should have_selector("select#work_orderer_id > option",
                                  count: user.orderers.size + 1) }
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
