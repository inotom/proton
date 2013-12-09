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
end
