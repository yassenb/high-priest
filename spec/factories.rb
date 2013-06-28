require "heroes/hero"

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

    factory :player_with_hero_picks do
      after(:create) do |player, evaluator|
        Heroes.all.take(HeroPick::NPICKS).map do |hero|
          FactoryGirl.create(:hero_pick, player: player, hero: hero)
        end
      end
    end
  end

  factory :hero_pick do
    player
    hero Heroes.all.first
  end
end
