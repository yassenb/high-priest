require "heroes/hero"
require "support/random_sample"

class Player < ActiveRecord::Base
  PHASES = %w(joined picked_hero playing)

  include Heroes::Base

  belongs_to :game
  belongs_to :user
  has_many :hero_picks, dependent: :destroy

  validates_presence_of :game_id, :user_id
  validates_presence_of :hero_id, unless: Proc.new { |player| player.phase == "joined" }
  validates_uniqueness_of :user_id, scope: :game_id
  validates_inclusion_of :phase, in: PHASES

  def pick_heroes
    assert_player_phase "joined"
    heroes = Support.random_sample(Heroes.all, HeroPick::NPICKS, false)
    heroes.map do |hero|
      HeroPick.create({ player: self, hero: hero }, without_protection: true)
    end
    heroes
  end

  def pick_hero(id)
    assert_player_phase "joined"

    self.hero = hero_picks.find_by_hero_id(id).try(:hero)
    raise "Invalid hero pick" unless hero

    self.phase = "picked_hero"
    save!
  end

  def pick_allies
    assert_player_phase "picked_hero"
    # TODO
  end

  def pick_spells
    assert_player_phase "picked_hero"
    # TODO
  end

  def swap_ally
    assert_player_phase "picked_hero"
    raise "Can't swap ally twice" if swapped_ally?
    # TODO
    self.swapped_ally = true
    play_if_swapping_done
    save!
  end

  def swap_spell
    assert_player_phase "picked_hero"
    raise "Can't swap spell twice" if swapped_spell?
    # TODO
    self.swapped_spell = true
    play_if_swapping_done
    save!
  end

  def swapping_done?
    swapped_ally? && swapped_spell?
  end

  private

  def play_if_swapping_done
    self.phase = "playing" if swapping_done?
  end

  def assert_player_phase(expected_phase)
    raise "Expected phase #{expected_phase} but got #{phase}" unless phase == expected_phase
  end
end
