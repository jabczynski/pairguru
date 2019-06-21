FactoryBot.define do
  factory :user do
    name { Faker::Lorem.word }
    email { Faker::Internet.email }
    password "password"
    confirmed_at { Time.zone.now }
  end
end
