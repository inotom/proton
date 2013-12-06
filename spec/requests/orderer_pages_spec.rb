require 'spec_helper'

describe "Orderer pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "orderers index" do
    let!(:o1) { FactoryGirl.create(:orderer, user: user, name: 'Orderer1') }
    let!(:o2) { FactoryGirl.create(:orderer, user: user, name: 'Orderer2') }
    before { visit orderers_path }

    it { should have_title('Orderers') }
    it { should have_content('Orderers') }
    it { should have_button('Create Orderer') }
    it { should have_link('Back', root_path) }

    describe "orderers" do
      it { should have_content(o1.name) }
      it { should have_content(o2.name) }
      it { should have_link('Delete') }
    end

    describe "should not show another user orderers" do
      let(:another_user) { FactoryGirl.create(:user,
                                              email: 'another_user@example.com') }
      let!(:o3) { FactoryGirl.create(:orderer,
                                     user: another_user,
                                     name: 'Orderer3') }
      before { visit orderers_path }

      it { should_not have_content(o3.name) }
    end
  end

  describe "orderer creation" do
    before { visit orderers_path }

    describe "with invalid information" do

      it "should not create a orderer" do
        expect { click_button 'Create Orderer' }.not_to change(Orderer, :count)
      end

      describe "error messages" do
        before { click_button 'Create Orderer' }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'orderer_name', with: 'New Orderer' }
      it "should create a orderer" do
        expect { click_button 'Create Orderer' }.to change(Orderer, :count).by(1)
      end
    end
  end

  describe "orderer destruction" do
    before { FactoryGirl.create(:orderer, user: user) }

    describe "as correct user" do
      before { visit orderers_path }

      it "should delete a orderer" do
        expect { click_link "Delete", match: :first }.to change(Orderer, :count).by(-1)
      end
    end
  end
end
