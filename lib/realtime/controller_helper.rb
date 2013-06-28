module RealTime
  module ControllerHelper
    def current_player
      @game.players.find_by_user_id @sender
    end
  end
end
