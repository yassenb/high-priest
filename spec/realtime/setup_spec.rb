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
    it "" do
      # TODO
    end
  end

  describe "#swap_ally" do
    it "" do
      # TODO
    end
  end

  describe "#swap_spell" do
    it "" do
      # TODO
    end
  end
end
