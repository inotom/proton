require 'spec_helper'

describe ApplicationHelper do

  describe 'full_title' do
    it 'should include the page title' do
      expect(full_title('foo')).to match(/foo/)
    end

    it 'should include the base title' do
      expect(full_title('foo')).to match(/ - Proton$/)
    end

    it 'should not include a separator in the home page' do
      expect(full_title('')).not_to match(/ - /)
    end
  end

  describe 'worktime_fmt' do
    it 'should return blank if time is nil' do
      expect(worktime_fmt(nil)).to be_nil
    end
  end

  describe 'total_worktimes_fmt' do
    it 'shoud return blank hour and minute' do
      expect(total_worktimes_fmt(0)).to match(/^\s*$/)
    end

    it 'shoud return blank hour' do
      expect(total_worktimes_fmt(59.minutes)).to match(/^\s*59\sminutes$/)
    end

    it 'shoud return blank minute' do
      expect(total_worktimes_fmt(1.hour)).to match(/^1\shour\s*$/)
    end

    it 'shoud return one minute' do
      expect(total_worktimes_fmt(1.minute)).to match(/^\s*1\sminute$/)
    end

    it 'shoud return full hours and minutes' do
      expect(total_worktimes_fmt(2.hours + 30.minutes)).to match(/^2\shours\s30\sminutes$/)
    end

    it 'shoud return full hours and minutes (1day over)' do
      expect(total_worktimes_fmt(1.day + 30.minutes)).to match(/^24\shours\s30\sminutes$/)
    end
  end

  describe 'payment_rate' do
    let(:user) { FactoryGirl.create(:user) }

    describe 'no payment and no worktime' do
      let(:work) { FactoryGirl.create(:work, user: user, title: 'New Work') }
      let!(:worktime) { FactoryGirl.create(:worktime,
                                           start_time: 15.minutes.ago,
                                           work: work) }
      before { sign_in user }

      it 'shoud return zero payment rate' do
        expect(work.payment_rate).to eq(0)
      end
    end

    describe 'no payment' do
      let(:work) { FactoryGirl.create(:work,
                                      user: user,
                                      payment: nil,
                                      title: 'New Work') }
      let!(:worktime) { FactoryGirl.create(:worktime,
                                           start_time: 15.minutes.ago,
                                           end_time: 10.minutes.ago,
                                           work: work) }
      before { sign_in user }

      it 'should return zero payment rate' do
        expect(work.payment_rate).to eq(0)
      end
    end

    describe 'no worktime' do
      let(:work) { FactoryGirl.create(:work, user: user, title: 'New Work') }
      let!(:worktime) { FactoryGirl.create(:worktime,
                                           start_time: 15.minutes.ago,
                                           work: work) }
      before { sign_in user }

      it 'should return zero payment rate' do
        expect(work.payment_rate).to eq(0)
      end
    end

    describe 'has payment and worktime' do
      let(:work) { FactoryGirl.create(:work,
                                      user: user,
                                      payment: 542,
                                      title: 'New Work') }
      let!(:worktime) { FactoryGirl.create(:worktime,
                                           start_time: 24.minutes.ago,
                                           end_time: 11.minutes.ago,
                                           work: work) }
      before { sign_in user }

      it 'should return correct payment rate' do
        expect(work.payment_rate).to eq(2502)
      end
    end
  end

  describe 'todos' do
    let(:user) { FactoryGirl.create(:user) }
    let(:work) { FactoryGirl.create(:work,
                                    user: user,
                                    title: 'New Work') }
    before { sign_in user }

    it 'should have no todos' do
      expect(work.unresolved_todos.size).to eq(0)
    end

    describe 'create a todo' do
      let!(:todo) { FactoryGirl.create(:todo, work: work) }

      it 'should have one todo' do
        expect(work.unresolved_todos.size).to eq(1)
      end
    end
  end
end
