$ ->
  $('#sendButton').click ->
    send 'chat', {text: $('#input').val()}
    $('#input').val ''

  subscribe 'chat', (data) ->
    $('#log').append "#{_.escape data.user}: #{_.escape data.text}\n"
