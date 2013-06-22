describe ChatController do
  describe "#index" do
    it "sends a message to all players in a game" do
      game = FactoryGirl.create(:game_with_two_players)
      sender = game.users.first

      message = { type: "chat", data: { text: "spam", user: sender.username } }
      described_class.new(game, sender, { "text" => "spam" })
        .should send_messages(:index, game.users.map { |user| [user, message] })
    end
  end
end
