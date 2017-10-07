FactoryGirl.define do
  factory :phoenix do
    owner

    name 'Foobar'
    image_id 1
    ssh_key_id 1
    size '2gb'

    factory :phoenix_with_droplet do
      droplet_id 1
    end

    factory :phoenix_with_users do
      transient do
        users_count 5
      end

      after(:create) do |phoenix, evaluator|
        create_list(:user, evaluator.users_count, phoenix: phoenix)
      end
    end
  end
end
