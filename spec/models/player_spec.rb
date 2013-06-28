describe Player do
  describe "#pick_heroes" do
    it "creates 3 hero picks" do
      player = FactoryGirl.create(:player)
      player.pick_heroes
      player.hero_picks.size.should == 3
    end
  end

  describe "#pick_hero" do
    it "picks a hero and moves to the next phase" do
      player = FactoryGirl.create(:player, :with_hero_picks)
      hero = player.hero_picks.first.hero

      player.pick_hero hero.id

      player.hero.should == hero
      player.phase.should == "picked_hero"
    end

    it "allows picking only a hero from the available picks" do
      player = FactoryGirl.create(:player, :with_hero_picks)
      hero = (Heroes.all - player.hero_picks.map(&:hero)).first

      expect { player.pick_hero hero.id }.to raise_error("Invalid hero pick")
    end
  end

  describe "#pick_allies" do
    it "creates 3 allies" do
      player = FactoryGirl.create(:player, :picked_hero)
      player.pick_allies
      player.allies.size.should == 3
    end
  end

  describe "#pick_spells" do
    it "creates 3 spells" do
      player = FactoryGirl.create(:player, :picked_hero)
      player.pick_spells
      player.spells.size.should == 3
    end
  end

  describe "#swap_ally" do
    it "allows swapping one of the given allies for another" do
      player = FactoryGirl.create(:player, :with_allies)
      player_allies = player.allies.map(&:ally)
      ally = player_allies.first
      new_ally = (Allies.all - player_allies).first

      expected_allies = player_allies.to_set
      expected_allies.delete ally
      expected_allies << new_ally

      Support.should_receive(:random_sample).with(Allies.all).and_return(new_ally)

      player.swap_ally ally.id

      player.reload
      player.allies.map(&:ally).to_set.should == expected_allies
    end

    it "allows skipping swapping" do
      player = FactoryGirl.create(:player, :with_allies)
      player_allies = player.allies.map(&:ally).to_set

      player.swap_ally nil

      player.reload
      player.allies.map(&:ally).to_set.should == player_allies
    end

    it "doesn't allow swapping unexistant ally" do
      player = FactoryGirl.create(:player, :with_allies)
      ally = (Allies.all - player.allies.map(&:ally)).first

      expect { player.swap_ally ally.id }.to raise_error("Ally not present")
    end

    it "doesn't allow swapping twice" do
      player = FactoryGirl.create(:player, :with_allies)
      ally = player.allies.first.ally
      player.swap_ally ally.id

      expect { player.swap_ally ally.id }.to raise_error("Can't swap ally twice")
    end

    it "goes to the playing phase if a spell was already swapped" do
      player = FactoryGirl.create(:player, :with_allies, swapped_spell: true)
      player.swap_ally player.allies.first.ally.id

      player.phase.should == "playing"
    end
  end

  describe "#swap_spell" do
    it "allows swapping one of the given spells for another" do
      player = FactoryGirl.create(:player, :with_spells)
      player_spells = player.spells.map(&:spell)
      spell = player_spells.first
      new_spell = (Spells.all - player_spells).first

      expected_spells = player_spells.to_set
      expected_spells.delete spell
      expected_spells << new_spell

      Support.should_receive(:random_sample).with(Spells.all).and_return(new_spell)

      player.swap_spell spell.id

      player.reload
      player.spells.map(&:spell).to_set.should == expected_spells
    end

    it "allows skipping swapping" do
      player = FactoryGirl.create(:player, :with_spells)
      player_spells = player.spells.map(&:spell).to_set

      player.swap_spell nil

      player.reload
      player.spells.map(&:spell).to_set.should == player_spells
    end

    it "doesn't allow swapping unexistant spell" do
      player = FactoryGirl.create(:player, :with_spells)
      spell = (Spells.all - player.spells.map(&:spell)).first

      expect { player.swap_spell spell.id }.to raise_error("Spell not present")
    end

    it "doesn't allow swapping twice" do
      player = FactoryGirl.create(:player, :with_spells)
      spell = player.spells.first.spell
      player.swap_spell spell.id

      expect { player.swap_spell spell.id }.to raise_error("Can't swap spell twice")
    end

    it "goes to the playing phase if an ally was already swapped" do
      player = FactoryGirl.create(:player, :with_spells, swapped_ally: true)
      player.swap_spell player.spells.first.spell.id

      player.phase.should == "playing"
    end
  end
end
