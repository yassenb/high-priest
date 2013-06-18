module FayeExtensions
  class UserAuthentication
    def incoming(message, callback)
      if message["channel"] == "/meta/subscribe"
        match = message["subscription"].match %r{^/game/(\d+)/(\d+)}
        if match
          game_id, user_id = match[1..2]
          game = Game.find(game_id)
          user_id_by_token = message["ext"] && User.find_by_token(message["ext"]["token"]).try(:id)
          unless user_id_by_token && user_id == user_id_by_token.to_s &&
                 game && game.players.find_by_user_id(user_id)
            message["error"] = "403::User not in game"
          end
        else
          message["error"] = "403::Subscription not allowed"
        end
      end
      callback.call message
    end
  end
end
