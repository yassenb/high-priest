describe SetupController do
  describe "#ready" do
    it "sends setup/heroes with the hero picks" do
      player = FactoryGirl.create(:player)
      sender = player.user
      heroes = Heroes.all.take(HeroPick::NPICKS)
      Support.should_receive(:random_sample).with(Heroes.all, HeroPick::NPICKS, false).and_return(heroes)

      heroes_data = heroes.map { |hero| { id: hero.id, name: hero.name } }
      described_class.new(player.game, sender, {})
        .should send_messages(:ready, [[sender, { type: "setup/heroes", data: heroes_data }]])
    end
  end

  describe "#pick_hero" do
    it "sends setup/allies and setup/spells with the picked allies and spells" do
      player = FactoryGirl.create(:player, :with_hero_picks)
      sender = player.user
      allies = Allies.all.take(Allies::NSTARTING)
      Support.should_receive(:random_sample).with(Allies.all, Allies::NSTARTING).and_return(allies)
      spells = Spells.all.take(Spells::NSTARTING)
      Support.should_receive(:random_sample).with(Spells.all, Spells::NSTARTING).and_return(spells)

      allies_data = allies.map { |ally| { id: ally.id, name: ally.name } }
      spells_data = spells.map { |spell| { id: spell.id, name: spell.name } }
      described_class.new(player.game, sender, { "id" => player.hero_picks.first.hero.id })
        .should send_messages(:pick_hero, [
          [sender, { type: "setup/allies", data: allies_data }],
          [sender, { type: "setup/spells", data: spells_data }],
        ])
    end
  end

  describe "#swap_ally" do
    it "sends setup/new_ally with the new ally" do
      player = FactoryGirl.create(:player, :with_allies)
      sender = player.user
      allies = player.allies.map(&:ally)
      new_ally = (Allies.all - allies).first
      Support.should_receive(:random_sample).with(Allies.all).and_return(new_ally)

      new_ally_data = { id: new_ally.id, name: new_ally.name }
      described_class.new(player.game, player.user, { "id" => allies.first.id })
        .should send_messages(:swap_ally, [[sender, { type: "setup/new_ally", data: new_ally_data }]])
    end

    it "sends nothing when no ally was swapped" do
      player = FactoryGirl.create(:player, :with_allies)
      described_class.new(player.game, player.user, {}).should send_messages(:swap_ally, [])
    end
  end

  describe "#swap_spell" do
    it "sends setup/new_spell with the new spell" do
      player = FactoryGirl.create(:player, :with_spells)
      sender = player.user
      spells = player.spells.map(&:spell)
      new_spell = (Spells.all - spells).first
      Support.should_receive(:random_sample).with(Spells.all).and_return(new_spell)

      new_spell_data = { id: new_spell.id, name: new_spell.name }
      described_class.new(player.game, player.user, { "id" => spells.first.id })
        .should send_messages(:swap_spell, [[sender, { type: "setup/new_spell", data: new_spell_data }]])
    end

    it "sends nothing when no spell was swapped" do
      player = FactoryGirl.create(:player, :with_spells)
      described_class.new(player.game, player.user, {}).should send_messages(:swap_spell, [])
    end
  end
end
