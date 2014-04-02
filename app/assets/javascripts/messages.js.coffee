$ ->

  $("#clear_messages").click( ->
    # Submit ajax and show no unread messages here.
    console.log("clearing messages")
    $.post("/messages/mark_all_read", (data) ->
      $("ul#messages").html("<li><a href='javascript: void(0);'>You have no unread messages</a></li>")
      $("#unread_message_count").hide()
      return
    )
    return
  )


  $("ul#messages li a").click( (event) ->
    event.preventDefault()
    messageId = $(this).data("message-id")
    href = $(this).attr("href")
    if messageId
      $.post("/messages/#{messageId}/mark_read", (data) ->
        window.location.href = href
      )
  )
