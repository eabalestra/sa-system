#

FactoryBot.define do
  factory :user do
    name { "TestUser" }
    email { "mail@gmail.com" }
    password { "123456" }
  end
end
