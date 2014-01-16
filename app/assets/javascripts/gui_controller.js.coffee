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
    $("#stop-recording").show()
    $("#start-text-highlight").show()

  $("#stop-recording").click ->
    recorder = window.autoTestRecorder
    recorder.stop()
    stepsRecorded = []
    $.each recorder.currentScenario.autoTestSteps, (i, step) ->
      stepsRecorded.push([i+1, ":", "Type is #{step.type}, text is #{step.text}", "\n"])

    stepsRecorded = _.sortBy(_.toArray(stepsRecorded), (step) -> step[0])
    alert("Your Steps have been recorded. Here are your steps:\n" + _.flatten(stepsRecorded).join(' '))
    $("#stop-recording").hide()
    ("#start-text-highlight").hide()
    $("#record").show()

  # Text highlighting
  $("button#start-text-highlight").click (e)->
    e.preventDefault()
    $(this).hide()
    $("#highlight-helper").show()
    $("button#record-text-highlight").show()
    $('body').mouseup ()->
      text = if document.all then document.selection.createRange().text else document.getSelection()
      $("#highlighted-text").text("#{text}")

  $("button#record-text-highlight").click (e) ->
    e.preventDefault()
    $(this).hide()
    $("#highlight-helper").hide()
    $("button#start-text-highlight").show()
    $("#highlighted-text").text('')
    $('body').unbind('mouseup')
    window.autoTestRecorder.recordHighlight($("#highlighted-text").text())
