$ ->

  $("#show_project_advanced_settings").click( ->
    $("#advanced_settings").slideDown();
    $("#show_project_advanced_settings").hide()
    $("#hide_project_advanced_settings").show()
  )
  $("#hide_project_advanced_settings").click( ->
    $("#advanced_settings").slideUp()
    $("#hide_project_advanced_settings").hide()
    $("#show_project_advanced_settings").show()
  )

  $("#dev_emails").tagsInput
    width: "100%"
    height: "100%"
    defaultText: ""


  $(".send-emails-to-dev").click (e)->
    $(this).siblings("#sending-emails-message").show()
    $(this).attr("disabled", true)
    $(this).parents('.modal-content').find('form').submit()
