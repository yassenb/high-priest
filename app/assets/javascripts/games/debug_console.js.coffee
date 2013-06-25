log = (message) ->
  el = $('#debugLog')
  el.val(el.val() + message)
  el.scrollTop el[0].scrollHeight

originalSend = send
@send = (type, data) ->
  log "sending: #{JSON.stringify {type, data}}\n"
  originalSend(type, data)

$ ->
  $('#debugLog').val ''

  client = new Faye.Client '/faye'
  client.addExtension {
    outgoing: (message, callback) ->
      message.ext ?= {}
      message.ext.token = $('#token').text()
      callback message
  }

  channel = "/game/#{$('#game_id').text()}/#{$('#user_id').text()}"
  client.subscribe channel, (message) ->
    log "receiving: #{JSON.stringify message}\n"

  $('#fakeBackendButton').click ->
    client.publish channel, JSON.parse($('#fakeBackendInput').val())
    $('#fakeBackendInput').val ''

  $('#fakeBackendInput').keyup (event) ->
    key = String.fromCharCode event.which
    if key == '\r'
      $('#fakeBackendButton').click()
