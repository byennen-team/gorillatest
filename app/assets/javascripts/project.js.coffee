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