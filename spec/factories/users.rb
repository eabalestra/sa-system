#

FactoryBot.define do
  factory :user do
    name { "TestUser" }
    email { "mail@gmail.com" }
    password { "123456" }
    actual_balance { 0 }
  end
end
