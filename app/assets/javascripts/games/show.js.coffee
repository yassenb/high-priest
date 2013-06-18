#= require_self
#= require_tree ./ui

client = new Faye.Client '/faye'
client.addExtension {
  outgoing: (message, callback) ->
    message.ext ?= {}
    message.ext.token = $('#token').text()
    callback message
}

@send = (type, data) ->
  client.publish  "/game/#{$('#game_id').text()}", {type, data}

subscribers = []
@subscribe = (type, callback) ->
  subscribers.push {type, callback}

$ ->
  subscribtion = client.subscribe "/game/#{$('#game_id').text()}/#{$('#user_id').text()}", (message) ->
    for {type, callback} in subscribers
      if type is message.type
        callback message.data

  $('#leaveButton').click ->
    subscribtion.cancel()
