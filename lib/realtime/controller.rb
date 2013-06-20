module RealTime
  class Controller
    def initialize(server_client, game, sender, data)
      @server_client = server_client
      @game = game
      @sender = sender
      @data = data
    end

    def send(user, data)
      @server_client.publish "/game/#{@game.id}/#{user.id}", data
    end
  end
end
