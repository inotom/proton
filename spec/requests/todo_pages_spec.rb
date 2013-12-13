require 'spec_helper'

describe "Todo Pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:work, user: user, title: 'New Work') }

  before { sign_in user }

  describe "todo creation" do

    before { visit work_path(work) }

    describe "with invalid information" do

      it "should not create a todo" do
        expect { click_button "Create Todo" }.not_to change(Todo, :count)
      end

      describe "error messages" do
        before { click_button "Create Todo" }
        it { should have_content("error") }
      end
    end

    describe "with valid information" do
      before { fill_in "todo_title", with: "New Todo" }
      it "should create a todo" do
        expect { click_button "Create Todo" }.to change(Todo, :count).by(1)
      end
    end
  end

  describe "todo destruction" do
    before { FactoryGirl.create(:todo, work: work) }

    describe "as correct user" do
      before { visit work_path(work) }

      it { should have_selector('.todo-delete a') }

      it "should delete a todo" do
        expect { find('.todo-delete').click_link "Delete" }.to change(Todo, :count).by(-1)
      end
    end
  end
end
