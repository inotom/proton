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
end
