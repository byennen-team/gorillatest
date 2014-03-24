$ ->
  $(document).ajaxSend (e, xhr, options) ->
    xhr.setRequestHeader "Authorization", "Token token=#{Autotest.authToken}"
    return

  return