require 'spec_helper'

describe Worktime do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @work = user.works.create(title: 'New Work')
    @worktime = @work.worktimes.build()
  end

  subject { @worktime }

  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:memo) }
  it { should respond_to(:work_id) }

  it { should be_valid }

  describe "when start_time is not present" do
    before { @worktime.start_time = nil }
    it { should_not be_valid }
  end

  describe "when work_id is not present" do
    before { @worktime.work_id = nil }
    it { should_not be_valid }
  end

end
