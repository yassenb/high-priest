class SetupController < RealTime::Controller
  def ready
    heroes = current_player.pick_heroes
    send @sender, { type: "setup/heroes", data: heroes.map { |hero| { id: hero.id, name: hero.name } } }
  end

  def pick_hero
    current_player.pick_hero @data["id"]
    allies = current_player.pick_allies
    spell = current_player.pick_spells

    send @sender, { type: "setup/allies", data: allies.map { |ally| { id: ally.id, name: ally.name } } }
    send @sender, { type: "setup/spells", data: spells.map { |spell| { id: spell.id, name: spell.name } } }
  end

  def swap_ally
    ally = current_player.swap_ally(@data["id"])
    send @sender, { type: "setup/new_ally", data: { id: ally.id, name: ally.name } }
  end

  def swap_spell
    spell = current_player.swap_spell(@data["id"])
    send @sender, { type: "setup/new_spell", data: { id: spell.id, name: spell.name } }
  end
end
