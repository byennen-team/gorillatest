$ ->

  $("#clear_messages").click( ->
    # Submit ajax and show no unread messages here.
    console.log("clearing messages")
    $.post("/messages/mark_read", (data) ->
      $("ul#messages").html("<li>You have no unread messages</li>")
      $("#unread_message_count").hide()
      return
    )
    return
  )
  return
