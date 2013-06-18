module FayeExtensions
  class PushOnly
    SERVER_TOKEN = SecureRandom.base64(20)

    class Client
      def outgoing(message, callback)
        message["ext"] ||= {}
        message["ext"]["server_token"] = SERVER_TOKEN
        callback.call message
      end
    end

    def initialize(server_client)
      @server_client = server_client
      @server_client.add_extension Client.new
    end

    def incoming(message, callback)
      if message["channel"] !~ %r{^/meta/}
        unless message["ext"] && crypto_equal(message["ext"]["server_token"], SERVER_TOKEN)
          process message
          message["error"] = "403::Only the server can push messages"
        end
      end
      callback.call message
    end

    def outgoing(message, callback)
      if message["ext"]
        message["ext"]["server_token"] = nil
      end
      callback.call message
    end

    def process(message)
      match = message["channel"].match %r{^/game/(\d+)}
      return unless match
      game_id = match[1]
      game = Game.find(game_id)
      user = message["ext"] && User.find_by_token(message["ext"]["token"])
      return unless game && user && game.players.find_by_user_id(user.id)

      # TODO move from here below to a separate function
      game.players.map { |player| player.user.id }.each do |user_id|
        @server_client.publish "/game/#{game_id}/#{user_id}",
          {type: "chat", data: {text: message["data"]["data"]["text"], user: user.username}}
      end
    end

    def crypto_equal(s1, s2)
      s1 && s2 && s1.length == s2.length &&
      s1.bytes.zip(s2.bytes).reduce(0) { |sum, (b1, b2)| sum |= b1 ^ b2 } == 0
    end
  end
end
