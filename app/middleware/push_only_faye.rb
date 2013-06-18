require "faye"

require "faye/push_only"
require "faye/user_authentication"

Faye::WebSocket.load_adapter("thin")

class PushOnlyFaye < Faye::RackAdapter
  def initialize(app=nil, options=nil)
    super
    add_extension FayeExtensions::UserAuthentication.new
    add_extension FayeExtensions::PushOnly.new(self.get_client)
  end
end
