$ ->
  $("select#features").on "change", ->
    if $(this).val().length > 0
      $("button#record").removeAttr("disabled")
    else
      $("button#record").attr("disabled", "disabled")

  $("input#scenario_name").on "keyup", ->
    if $(this).val().length > 0
      $("button#start-recording").removeAttr("disabled")
    else
      $("button#start-recording").attr("disabled", "disabled")
