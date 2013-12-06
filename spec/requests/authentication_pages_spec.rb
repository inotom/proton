require 'spec_helper'

describe 'AuthenticationPages' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger', text: 'Invalid') }
      it { should_not have_link('Users') }
      it { should_not have_link('Profile') }
      it { should_not have_link('Settings') }
      it { should_not have_link('Sign out') }
      it { should have_link('Sign in', href: signin_path) }

      describe 'after visiting another page' do
        before { click_link 'Home' }
        it { should_not have_selector('div.alert.alert-danger') }
      end
    end

    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      let!(:work) { FactoryGirl.create(:work, user: user, title: 'User Work1') }
      before { sign_in user }

      it { should have_title(full_title('Works')) }
      it { should have_content(work.title) }
      it { should have_link('Profile'    , href: user_path(user)) }
      it { should have_link('Settings'   , href: edit_user_path(user)) }
      it { should have_link('Sign out'   , href: signout_path) }
      it { should_not have_link('Users'  , href: users_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe 'as an admin user' do
        let(:admin) { FactoryGirl.create(:admin) }
        before { sign_in admin }

        it { should have_link('Users', href: users_path) }
      end

      describe 'followed by signout' do
        before { click_link 'Sign out' }

        it { should have_link('Sign in', href: signin_path) }
      end
    end
  end

  describe 'authorization' do

    describe 'for signed-in users' do
      let(:user) { FactoryGirl.create(:user) }

      describe 'visiting users new page' do
        before do
          sign_in user
          visit new_user_path
        end
        it { should have_link('Create work', href: new_work_path) }
        it { should_not have_content('Welcome to the Proton') }
      end

      describe 'submitting a CREATE request to the User#create action' do
        before do
          sign_in user, no_capybara: true
          post users_path(user)
        end
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe 'for non-signed-in users' do
      let(:user) { FactoryGirl.create(:user) }

      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in 'Email'   , with: user.email
          fill_in 'Password', with: user.password
          click_button 'Sign in'
        end

        describe 'after signing in' do

          it 'should render the desired protected page' do
            expect(page).to have_title('Edit user')
          end

          describe 'when signing in again' do
            before do
              delete signout_path
              visit signin_path
              fill_in 'Email'   , with: user.email
              fill_in 'Password', with: user.password
              click_button 'Sign in'
            end

            it 'should render the default page' do
              expect(page).to have_title(full_title('Works'))
            end
          end
        end
      end

      describe 'in the Works controller' do
        let(:work) { FactoryGirl.create(:work) }

        describe 'visiting the edit page' do
          before { visit edit_work_path(work) }
          it { should have_title('Sign in') }
        end

        describe 'submitting to the update action' do
          before { patch work_path(work) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe 'visiting the work show page' do
          before { visit work_path(work) }
          it { should have_title('Sign in') }
        end

        describe 'submitting to the destroy action' do
          before { delete work_path(work) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe 'visiting the work new page' do
          before { visit new_work_path(work) }
          it { should have_title('Sign in') }
        end

        describe 'submitting to the create action' do
          before { post works_path(work) }
          specify { expect(response).to redirect_to(signin_path) }
        end

      end

      describe 'in the Orderers controller' do

        describe 'submitting to the create action' do
          before { post orderers_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe 'submitting to the destroy action' do
          before { delete orderer_path(FactoryGirl.create(:orderer)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe 'in the Users contoroller' do

        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe 'submitting to the update action' do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe 'visiting the user index' do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe 'visiting the user show page' do
          before { visit user_path(user) }
          it { should have_title('Sign in') }
        end
      end
    end

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
      before { sign_in user, no_capybara: true }

      describe 'submitting a GET request to the User#edit action' do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_path) }
      end

      describe 'submitting a PATH request to the Users#update action' do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the User#destory action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
