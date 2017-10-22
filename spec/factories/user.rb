FactoryGirl.define do
  factory :user do
    username  { Faker::Internet.user_name }
    password  { Faker::Internet.password }
    email     { Faker::Internet.safe_email}

    factory :user_with_access_token, aliases: [:owner] do
      access_token { Faker::Internet.password }

      factory :user_with_phoenixes do
        transient do
          phoenixes_count 1
        end

        after(:create) do |user, evaluator|
          create_list(:phoenix, evaluator.phoenixes_count, owner: user, users: [user])
        end
      end
    end
  end
end
