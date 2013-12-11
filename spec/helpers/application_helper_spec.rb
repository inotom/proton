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
end
