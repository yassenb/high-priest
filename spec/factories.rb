require "heroes/hero"
require "allies/ally"
require "spells/spell"

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

    trait :with_hero_picks do
      after(:create) do |player, evaluator|
        Heroes.all.take(HeroPick::NPICKS).map do |hero|
          FactoryGirl.create(:hero_pick, player: player, hero: hero)
        end
      end
    end

    trait :picked_hero do
      hero Heroes.all.first
      phase "picked_hero"
    end

    trait :with_allies do
      picked_hero

      after(:create) do |player, evaluator|
        Allies.all.take(Allies::NSTARTING).map do |ally|
          FactoryGirl.create(:ally, player: player, ally: ally)
        end
      end
    end

    trait :with_spells do
      picked_hero

      after(:create) do |player, evaluator|
        Spells.all.take(Spells::NSTARTING).map do |spell|
          FactoryGirl.create(:spell, player: player, spell: spell)
        end
      end
    end
  end

  factory :hero_pick do
    player
    hero Heroes.all.first
  end

  factory :ally do
    player
    ally Allies.all.first
  end

  factory :spell do
    player
    spell Spells.all.first
  end
end
