FactoryBot.define do
  factory :user do
    name { Faker::Lorem.word }
    email { Faker::Internet.email }
    password { Faker::Lorem.sentence }
    confirmed_at { Time.zone.now }
  end
end
