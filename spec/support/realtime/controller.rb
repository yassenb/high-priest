module RealTime
  class Controller
    attr_reader :sent_messages

    def initialize(game, sender=game.users.first, data)
      @game = game
      @sender = sender
      @data = data
      @sent_messages = []
    end

    def send(user, data)
      @sent_messages << [user, data]
    end
  end
end
