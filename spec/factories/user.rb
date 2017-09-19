FactoryGirl.define do
  factory :user, aliases: [:owner] do
    username  "J3RN"
    password  "foobarbaz"
    email     "foo@example.com"
  end
end
