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
    $("#scenario_name").val('')
    recorder = window.autoTestRecorder
    event.preventDefault()
    recorder.addScenario($("input#scenario_name").val())
    recorder.record()
    $("#record").hide()
    recorder.currentScenario.addStep("get", {type: '', value: ''}, window.location.href)
    $("#stop-recording").show()
    $("#start-text-highlight").show()

  $("#stop-recording").click ->
    $(".recording-bar").removeClass("recording")
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
    e.stopPropagation()
    $(this).hide()
    $("button#record-text-highlight").show()
    $("body *").hover(hoverOutline)
    $("html").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar *").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar *").unbind("click")
    $("*").css('cursor', 'crosshair')
    $("body *").bind 'click', (eve) ->
      eve.stopPropagation()
      $("#element-modal").modal('show')
      $("#element-modal *").css('cursor', 'auto')
      $("#element-modal *").css("outline", "none")
      $("#element-modal *").unbind("mouseenter").unbind("mouseleave")
      $("#element-modal").unbind("click")
      $("#element-modal *").unbind("click")
      $("#record-element-text").html($(this).text())
      $("#record_text_text").val($(this).text())
      $("#record-element-html").text($(this).clone().removeAttr("style").wrap("<p>").parent().html())
      $("#record_text_element_html").val($(this).clone().removeAttr("style").wrap("<p>").parent().html())
      $(".close-element-modal").bind 'click', ->
        $("#element-modal").modal('hide')
      $(".validation-radio").click ->
        $("#save-validation").removeAttr('disabled', false)
      $("#save-validation").bind 'click', (e) ->
        e.preventDefault()
        checked = $("input[name=record_text]:checked")
        text = checked.val()
        type = if checked.attr("id") is "record_text_text" then "verifyText" else "verifyElementPresent"
        autoTestRecorder.currentScenario.addStep(type, {type: '', value: ''}, text)


    $("a, button, input[type='submit'], select").bind "click", (ev) ->
      ev.preventDefault()

  hoverOutline = (event) ->
    event.stopPropagation
    $("*").css("outline", "none")
    $(this).css("outline", "2px solid red")
    $(this).mouseleave (e) ->
      e.stopPropagation()
      $(this).css("outline", "none")
    return

  window.hoverOutline = hoverOutline

  $("button#record-text-highlight").click (e) ->
    e.preventDefault()
    $(this).hide()
    $("#highlight-helper").hide()
    $("button#start-text-highlight").show()
    $("#highlighted-text").text('')
    $('body').unbind('mouseup')
    window.autoTestRecorder.recordHighlight($("#highlighted-text").text())
