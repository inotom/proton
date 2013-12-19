require 'spec_helper'

describe Orderer do

  let(:user) { FactoryGirl.create(:user) }
  before { @orderer = user.orderers.build(name: 'Orderer Name') }

  subject { @orderer }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:color_index) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @orderer.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @orderer.name = '' }
    it { should_not be_valid }
  end

  describe "with name is too long" do
    before { @orderer.name = 'a' * 256 }
    it { should_not be_valid }
  end
end
