require 'spec_helper'

describe "Authentication" do
  subject { page }
  describe "signin page" do
    before {visit signin_path}
    it {should have_content('Sign In')}
    #it should have email text field
    #password text field
    #submit button
    it {should have_selector('input', id: "email", type: 'text')}
    it {should have_selector('input', id: "password", type: 'password')}
    it {should have_selector('input', type: 'submit', value: 'Sign In')}
    #it should not have sidebar
    it {should_not have_content('Applications')}
    it {should_not have_content('Roles')}
    it {should_not have_content('Users')}
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
        visit signin_path
        fill_in "Email", with: APP_CONFIG[:ldap_user]
        fill_in "Password", with: APP_CONFIG[:ldap_user_pw]
        click_button 'Sign In'
      end
      it {should have_content('Welcome to LMP')}
      after do
        @user = User.find_by_email(APP_CONFIG[:ldap_user])
        @user.destroy
      end
    end
  end
end
