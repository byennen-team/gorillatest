$ ->

  $("#clear_messages").click( ->
    # Submit ajax and show no unread messages here.
    $.post("/messages/mark_all_read", (data) ->
      $("ul#messages").html("<li><a href='javascript: void(0);'>You have no unread messages</a></li>")
      $("#unread_message_count").hide()
      return
    )
    return
  )


  $("ul#messages li a").click( (event) ->
    window.messageClickBehavior(this, event)
  )

@messageClickBehavior = (element, event) ->
  _this = element
  event.preventDefault()
  messageId = $(_this).data("message-id")
  href = $(_this).attr("href")
  if messageId
    $.post("/messages/#{messageId}/mark_read", (data) ->
      window.location.href = href
      $(_this).parent().remove()
      if $("#unread_message_count").text()-1 > 0
        $("#unread_message_count").text($("#unread_message_count").text()-1)
      else
        $("ul#messages").prepend('<li><a href="javascript: void(0);">You have no unread messages</a></li>')
        $("#unread_message_count").hide()
    )
