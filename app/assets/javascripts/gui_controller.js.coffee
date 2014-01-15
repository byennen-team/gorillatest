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

  $("#start-recording").click (event) ->
    $("#add-scenario").modal("hide")
    recorder = window.autoTestRecorder
    event.preventDefault()
    recorder.addScenario($("input#scenario_name").val())
    recorder.record()
    $("#record").hide()
    $("#stop-recording").removeClass("hide")

  $("#stop-recording").click ->
    recorder = window.autoTestRecorder
    recorder.stop()
    stepsRecorded = []
    $.each recorder.currentScenario.autoTestSteps, (i, step) ->
      stepsRecorded.push([i+1, ":", "Type is #{step.type}, text is #{step.text}", "\n"])

    stepsRecorded = _.sortBy(_.toArray(stepsRecorded), (step) -> step[0])
    alert("Your Steps have been recorded. Here are your steps:\n" + _.flatten(stepsRecorded).join(' '))
    $("#stop-recording").addClass("hide")
    $("#record").show()
