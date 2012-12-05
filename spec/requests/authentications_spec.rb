require 'spec_helper'

describe "Authentication" do
  subject { page }
  describe "signin page" do
    before {visit root_path}
    it {should have_content('Sign In')}
    #it should have email text field
    #password text field
    #submit button
    it {should have_selector('input', id: "email", type: 'text')}
    it {should have_selector('input', id: "password", type: 'password')}
    it {should have_selector('input', type: 'submit', value: 'Sign In')}
    #it should not have sidebar
    it {should_not have_selector('div.well.sidebar-nav')}
    describe "click sign in with blank fields" do
      before { click_button 'Sign In'}
     it {should have_content('Email/Password cannot be empty')}
    end
    describe "click sign in with incorrect user information" do
      before  do
        fill_in "Email", with: "wrong@time4lime.com"
        fill_in "Password", with: "wrong_password"
        click_button 'Sign In'
      end
      it {should have_content ('Invalid credentials/Unauthorized')}
    end
    describe "click sign in with correct user information" do
      before do
        @user = FactoryGirl.create(:valid_ldap_user)
        sign_in_valid_user
      end
      it {should have_content('Landing page')}
      after do
        @user = User.find_by_email(APP_CONFIG[:ldap_user])
        @user.destroy
      end
    end
  end
  describe "signing out" do
    #attempting to visit home_path without signing in
    describe "visiting home page without signing in" do
      before {visit home_path}
      it {should have_content ("Sign In")}
      it {should have_selector('div.alert.alert-notice', text: 'Please sign in')}
    end
    describe "clicking sign out after signing in" do
      before do
        create_test_user
        visit root_path
        sign_in_valid_user
        click_link "Sign Out"
      end
      it {should have_content('Sign In')}
      it {should have_selector('div.alert.alert-notice', text: 'Thanks for signing out')}
      after {destroy_test_user}
    end
  end
end
