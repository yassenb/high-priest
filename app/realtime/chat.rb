class ChatController < RealTime::Controller
  def index
    @game.users.each do |user|
      send user, { type: "chat", data: { text: @data["text"], user: @sender.username } }
    end
  end
end
