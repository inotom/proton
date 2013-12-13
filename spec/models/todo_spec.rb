require 'spec_helper'

describe Todo do

  let(:user) { FactoryGirl.create(:user) }
  let(:work) { FactoryGirl.create(:work, user: user, title: 'New Work') }

  before do
    @todo = work.todos.build(title: 'New Todo')
  end

  subject { @todo }

  it { should respond_to(:title) }
  it { should respond_to(:status) }
  it { should respond_to(:work_id) }
  it { should respond_to(:work) }
  its(:work) { should eq work }

  it { should be_valid }

  describe "when work_id is not present" do
    before { @todo.work_id = nil }
    it { should_not be_valid }
  end

  describe "with blank title" do
    before { @todo.title = ' ' }
    it { should_not be_valid }
  end

  describe "with title that is too long" do
    before { @todo.title = 'a' * 256 }
    it { should_not be_valid }
  end
end
