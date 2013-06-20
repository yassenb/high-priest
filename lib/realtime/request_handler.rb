require "realtime/controller"

CONTROLLERS_GLOB = File.dirname(__FILE__) + "/../../app/realtime/**/*.rb"
Dir[CONTROLLERS_GLOB].each { |file| require file }

module RealTime
module_function

  def handle_request(server_client, game, sender, data)
    load_controllers if Rails.env.development?

    if data["type"].count("/") > 1
      raise ArgumentError.new "Wrong message type, only <name> and <name>/<name> are supported"
    end
    controller, method = data["type"].split("/")
    controller_class_name = controller.sub(/./) { |c| c.upcase } + "Controller"
    controller_class = Object.const_get controller_class_name
    method ||= "index"

    controller_class.new(server_client, game, sender, data["data"]).__send__ method
  end

  def load_controllers
    Dir[CONTROLLERS_GLOB].each { |file| load file }
  end

  private_class_method :load_controllers
end
