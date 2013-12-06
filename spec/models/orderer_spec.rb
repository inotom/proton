require 'spec_helper'

describe Orderer do

  let(:user) { FactoryGirl.create(:user) }
  before { @orderer = user.orderers.new(name: 'Orderer Name', user_id: user.id) }

  subject { @orderer }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @orderer.user_id = nil }
    it { should_not be_valid }
  end
end
