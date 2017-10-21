FactoryGirl.define do
  factory :user do
    username  "J3RN"
    password  "foobarbaz"
    email     "foo@example.com"

    factory :user_with_access_token, aliases: [:owner] do
      access_token 'asdfasfdasdfasdfasdf'
    end
  end
end
