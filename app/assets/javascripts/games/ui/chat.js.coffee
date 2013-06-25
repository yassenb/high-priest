$ ->
  $('#log').val ''

  $('#sendButton').click ->
    send 'chat', {text: $('#input').val()}
    $('#input').val ''

  subscribe 'chat', (data) ->
    $('#log').val($('#log').val() + "#{data.user}: #{data.text}\n")
