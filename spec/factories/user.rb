FactoryGirl.define do
  factory :user do
    username  "J3RN"
    password  "foobarbaz"
    email     "foo@example.com"

    factory :user_with_access_token, aliases: [:owner] do
      access_token 'asdfasfdasdfasdfasdf'

      factory :user_with_phoenixes do
        transient do
          phoenixes_count 1
        end

        after(:create) do |user, evaluator|
          create_list(:phoenix, evaluator.phoenixes_count, owner: user)
        end
      end
    end
  end
end
