require 'spec_helper'

describe Work do

  let(:user) { FactoryGirl.create(:user) }
  let(:orderer) { FactoryGirl.create(:orderer) }
  before { @work = user.works.build(title: 'New Work',
                                    payment: 100.0,
                                    other: 'Lerem ipsum',
                                    orderer_id: orderer.id) }

  subject { @work }

  it { should respond_to(:title) }
  it { should respond_to(:payment) }
  it { should respond_to(:other) }
  it { should respond_to(:finished) }
  it { should respond_to(:claimed) }
  it { should respond_to(:receipted) }
  it { should respond_to(:user_id) }
  it { should respond_to(:orderer_id) }
  it { should respond_to(:worktimes) }
  it { should respond_to(:todos) }

  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @work.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { @work.title = '' }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @work.title = "a" * 256 }
    it { should_not be_valid }
  end

  describe "worktimes associations" do

    before { @work.save }
    let!(:older_worktime) do
      FactoryGirl.create(:worktime,
                         work: @work,
                         start_time: 1.day.ago)
    end
    let!(:newer_worktime) do
      FactoryGirl.create(:worktime,
                         work: @work,
                         start_time: 1.hour.ago)
    end

    it "should have the right worktimes in the right order" do
      expect(@work.worktimes.to_a).to eq [newer_worktime, older_worktime]
    end

    it "should destroy associated worktimes" do
      worktimes = @work.worktimes.to_a
      @work.destroy
      expect(worktimes).not_to be_empty
      worktimes.each do |worktime|
        expect(Worktime.where(id: worktime.id)).to be_empty
      end
    end

    it "should destory user associated worktimes" do
      worktimes = @work.worktimes.to_a
      user.destroy
      expect(worktimes).not_to be_empty
      worktimes.each do |worktime|
        expect(Worktime.where(id: worktime.id)).to be_empty
      end
    end
  end

  describe "todos associations" do

    before { @work.save }
    let!(:older_todo) do
      FactoryGirl.create(:todo, work: @work, created_at: 1.day.ago)
    end
    let!(:newer_todo) do
      FactoryGirl.create(:todo, work: @work, created_at: 1.hour.ago)
    end

    it "should have the right todos in the right order" do
      expect(@work.todos.to_a).to eq [newer_todo, older_todo]
    end

    it "should destroy associated todos" do
      todos = @work.todos.to_a
      @work.destroy
      expect(todos).not_to be_empty
      todos.each do |todo|
        expect(Todo.where(id: todo.id)).to be_empty
      end
    end
  end
end
