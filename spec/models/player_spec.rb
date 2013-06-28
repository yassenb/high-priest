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
      player = FactoryGirl.create(:player_with_hero_picks)
      hero = player.hero_picks.first.hero

      player.pick_hero hero.id

      player.hero.should == hero
      player.phase.should == "picked_hero"
    end

    it "allows picking only a hero from the available picks" do
      player = FactoryGirl.create(:player_with_hero_picks)
      hero = (Heroes.all - player.hero_picks.map(&:hero)).first

      expect { player.pick_hero hero.id }.to raise_error("Invalid hero pick")
    end
  end

  describe "#pick_allies" do
    # TODO
  end

  describe "#pick_spells" do
    # TODO
  end

  describe "#swap_ally" do
    # TODO
  end

  describe "#swap_spell" do
    # TODO
  end
end
