FactoryGirl.define do
  factory :user do
    email { "#{username.split.join(".").downcase}@gmail.com" }

    password "secret123"
    password_confirmation { password }

    sequence(:username) { |n| "user#{n}" }
  end

  factory :game do
    sequence(:name) { |n| "game#{n}" }

    factory :game_with_creator do
      ignore do
        player_count 1
      end

      after(:create) do |game, evaluator|
        FactoryGirl.create_list(:player, evaluator.player_count, game: game)
      end

      factory :game_with_two_players do
        player_count 2
      end
    end
  end

  factory :player do
    game
    user
  end
end
