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
    recorder = window.autoTestRecorder
    event.preventDefault()
    recorder.addScenario($("input#scenario_name").val())
    recorder.record()    
    $("#add-scenario").modal("hide")
    $("#record").hide()
    recorder.currentScenario.addStep("get", {type: '', value: ''}, window.location.href)
    $("#stop-recording").show()
    $("#start-text-highlight").show()
    $("#scenario_name").val('')

  $("#stop-recording").click ->
    $(".recording-bar").removeClass("recording")
    $("select#features").removeAttr("disabled").show()
    $("#current-scenario").hide().html('')
    $("button#record").removeAttr("disabled")    
    $("#step-count-text").hide()
    $("#step-count").text('')
    recorder = window.autoTestRecorder
    recorder.stop()
    stepsRecorded = []
    $.each recorder.currentScenario.autoTestSteps, (i, step) ->
      stepsRecorded.push([i+1, ":", "Type is #{step.type}, text is #{step.text}", "\n"])

    stepsRecorded = _.sortBy(_.toArray(stepsRecorded), (step) -> step[0])
    alert("Your Steps have been recorded. Here are your steps:\n" + _.flatten(stepsRecorded).join(' '))
    $("#stop-recording").hide()
    $("#start-text-highlight").hide()
    $("#record").show()

  # Text highlighting
  $("button#start-text-highlight").click (e)->
    e.preventDefault()
    e.stopPropagation()
    $(this).hide()
    $("button#stop-record-text-highlight").show()
    $("body *").hover(autoTestGuiController.hoverOutline)
    $("html").unbind("mouseenter").unbind("mouseleave")
    $("*").css('cursor', 'crosshair')
    $("a").unbind("click")
    $("a, button, input[type='submit'], select").bind("click", autoTestGuiController.preventClicks)
    $("a").unbind("click", AutoTestEvent.bindEvent)
    $("body *").bind('click', autoTestGuiController.bindBodyClick)
    autoTestGuiController.unbindAutoTestBar()    

  $("button#stop-record-text-highlight").click (e) ->
    e.preventDefault()
    $(this).hide()
    $("#highlight-helper").hide()
    $("button#start-text-highlight").show()
    $("#highlighted-text").text('')
    $('body').unbind('mouseup')
    $("*").css('cursor', 'auto')    
    # window.autoTestRecorder.recordHighlight($("#highlighted-text").text())
    $("body *").unbind("click", AutoTestGuiController.bindBodyClick)
    $("body *").unbind("mouseenter").unbind("mouseleave")
    $("a, button, input[type='submit'], select").unbind("click", autoTestGuiController.preventClicks)
    $("a").bind("click", AutoTestEvent.bindEvent)       

  #create feature modal
  $("input#feature_name").on "keyup", ->
    if $(this).val().length > 0
      $("button#create-feature").removeAttr("disabled")
    else
      $("button#create-feature").attr("disabled", "disabled")

  $("button#create-feature").click (e) ->
    e.preventDefault()
    project_id = location.search.split('project_id=')[1]
    data = { feature: {name: $("#feature_name").val()} }

    $.ajax "/api/v1/projects/#{project_id}/features",
      type: "POST"
      data: data
      async: false
      beforeSend: (xhr, settings) ->
        xhr.setRequestHeader('Authorization', "Token token=\"#{window.authToken}\"")
      success: (data) ->
        $("#create-feature-modal").modal("hide")
        $("#feature_name").val('')
        feature = data.feature
        $("select#features").append "<option value=#{feature.id}>#{feature.name}</option>"
        $("select#features").val(feature.id)
        autoTestRecorder.setCurrentFeature(feature.id)
        $("button#record").removeAttr("disabled")

AutoTestGuiController = {

  unbindAutoTestBar: ->
    $("div.recording-bar").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar *").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar *").unbind("click", autoTestGuiController.bindBodyClick)
    return


  hoverOutline: (event) ->
    event.stopPropagation
    $("*").css("outline", "none")
    $(this).css("outline", "2px solid red")
    $(this).mouseleave (e) ->
      e.stopPropagation()
      $(this).css("outline", "none")
    return

  showElementModal: (event, element) ->
    $("#element-modal").modal('show')
    $("#element-modal *").css('cursor', 'auto')
    $("#element-modal *").css("outline", "none")
    $("#element-modal *").unbind("mouseenter").unbind("mouseleave")
    $("#element-modal").unbind("click")
    $("#element-modal *").unbind("click")
    $("#record-element-text").html($(element).text())
    $("#record_text_text").val($(element).text())
    $("#record-element-html").text($(element).clone().removeAttr("style").wrap("<p>").parent().html())
    $("#record_text_element_html").val($(element).clone().removeAttr("style").wrap("<p>").parent().html())
    $(".close-element-modal").bind 'click', ->
      $("#element-modal").modal('hide')
    $(".validation-radio").click ->
      $("#save-validation").removeAttr('disabled', false)
    $("#save-validation").bind 'click', (e) ->
      e.preventDefault()
      checked = $("input[name=record_text]:checked")
      type = if checked.attr("id") is "record_text_text" then "verifyText" else "verifyElementPresent"
      autoTestRecorder.currentScenario.addStep(type, {type: '', value: ''}, checked.val())
      $("#element-modal").modal("hide")
    return

  startRecording: (recorder) ->
    $("select#features").attr("disabled", "disabled")
    $("select#features").hide()
    $("#current-scenario").html("<strong>Currently recording: #{recorder.currentFeature.name} - #{recorder.currentScenario.name}</strong>").show()
    $("button#record").hide()
    $("button#stop-recording").show()
    $(".recording-bar").addClass("recording")
    $("button#start-text-highlight").show() 
    $("#step-count-text").show()

  bindBodyClick: (event) ->
    event.preventDefault()      
    event.stopPropagation()
    console.log("Showign element modal")
    autoTestGuiController.showElementModal(event, event.currentTarget)

  preventClicks: (event) ->
    event.preventDefault
    return false
}

window.autoTestGuiController = AutoTestGuiController