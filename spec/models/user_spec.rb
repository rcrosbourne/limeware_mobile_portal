require 'spec_helper'

describe User do
  before {@user = User.new(email: "foobar@time4lime.com", name: "Foo Bar")}
  subject{@user}
  it{should respond_to(:email)}
  it {should respond_to(:name)}
  it {should respond_to(:remember_token)}
  describe "attributes validations" do
    describe "for remember token" do
      before {@user.save}
      its(:remember_token) {should_not be_blank}
    end
    describe "for name " do
      describe "name should not be empty" do
        before{@user.name = " "}
        it {should_not be_valid}
      end
      describe "name should not have more than 50 characters " do
        before {@user.name = "a"*51}
        it {should_not be_valid}
      end
      describe "name should not have less than 3 characters" do
        before {@user.name = "a"*2 }
        it {should_not be_valid}
      end
    end
    describe "for email" do
      describe "email should not be empty" do
        before {@user.email = " "}
        it {should_not be_valid}
      end
      describe "email domain should be in must be time4lime or lime" do
        it "should not be valid" do
          invalid_address = %w[name.first@gmail.com name@hotmail.com name.first@nolime.com]
          invalid_address.each do |invalid_email|
            @user.email = invalid_email
            @user.should_not be_valid
          end
        end
        it "should be valid" do
          valid_address = %w[me@time4lime.com you.me@lime.com limeware@time4lime.com]
          valid_address.each do  |valid_email|
              @user.email = valid_email
              @user.should be_valid
          end
        end         
      end
      describe "uniqueness" do
        before do
          user_with_the_same_email = @user.dup
          user_with_the_same_email.email = @user.email.upcase
          user_with_the_same_email.save
        end
        it{should_not be_valid}
      end
    end
  end
  describe "LDAP validation wrong credentials" do
    before {@user = FactoryGirl.create(:valid_ldap_user) }
    it "should not be valid" do
        User.ad_authenticate(@user.email,"password").should be_false
    end
  end
  describe "LDAP validation correct credentials" do
    before { @user.email =  APP_CONFIG[:ldap_user] }
    it "should be valid" do
      User.ad_authenticate(@user.email, APP_CONFIG[:ldap_user_pw]).should be_true
    end
  end
  describe "User Authorization" do
    describe "before valid user is added to database" do
      before { @user = User.authorize(APP_CONFIG[:ldap_user], APP_CONFIG[:ldap_user_pw]) }
      it {should be_nil}
    end
    describe "after valid user is added to database" do
      before do
        User.create(name: APP_CONFIG[:ldap_user].split("@").first.titleize, email: APP_CONFIG[:ldap_user])
        @user = User.authorize(APP_CONFIG[:ldap_user], APP_CONFIG[:ldap_user_pw])
      end
       it {should be_valid}
      after do
         @user = User.find_by_email(APP_CONFIG[:ldap_user])
         @user.destroy
      end
    end
  end
end
