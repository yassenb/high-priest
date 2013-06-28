require "heroes/hero"
require "allies/ally"
require "spells/spell"
require "support/random_sample"

class Player < ActiveRecord::Base
  PHASES = %w(joined picked_hero playing)

  include Heroes::Base

  belongs_to :game
  belongs_to :user
  has_many :hero_picks, dependent: :destroy
  has_many :allies, dependent: :destroy
  has_many :spells, dependent: :destroy

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
    allies = Support.random_sample(Allies.all, Allies::NSTARTING)
    allies.map do |ally|
      Ally.create({ player: self, ally: ally }, without_protection: true)
    end
    allies
  end

  def pick_spells
    assert_player_phase "picked_hero"
    spells = Support.random_sample(Spells.all, Spells::NSTARTING)
    spells.map do |spell|
      Spell.create({ player: self, spell: spell }, without_protection: true)
    end
    spells
  end

  def swap_ally(id)
    assert_player_phase "picked_hero"
    raise "Can't swap ally twice" if swapped_ally?
    new_ally = nil

    if id
      ally = allies.find_by_ally_id(id)
      raise "Ally not present" unless ally
      new_ally = Support.random_sample(Allies.all)
      ally.update_attribute(:ally, new_ally)
    end

    self.swapped_ally = true
    play_if_swapping_done

    save!
    new_ally
  end

  def swap_spell(id)
    assert_player_phase "picked_hero"
    raise "Can't swap spell twice" if swapped_spell?
    new_spell = nil

    if id
      spell = spells.find_by_spell_id(id)
      raise "Spell not present" unless spell
      new_spell = Support.random_sample(Spells.all)
      spell.update_attribute(:spell, new_spell)
    end

    self.swapped_spell = true
    play_if_swapping_done

    save!
    new_spell
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
