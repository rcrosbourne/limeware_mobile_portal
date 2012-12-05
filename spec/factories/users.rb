# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :valid_ldap_user, class: User do
    name "Rainaldo Crosbourne"
    email "rainaldo.crosbourne@time4lime.com"
  end
  factory :user do
    name "MyString"
    email "MyString"
  end
end
