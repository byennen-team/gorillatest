$ ->
  AutoTestGuiController.enableTooltip()

  $("select#features").on "change", ->
    if $(this).val().length > 0
      $("button#record").removeAttr("disabled")
      AutoTestGuiController.disableTooltip()
    else
      $("button#record").attr("disabled", "disabled")
      AutoTestGuiController.enableTooltip()

  # $("iframe").contents().find("input#scenario_name").on "keyup", ->
  #   if $(this).val().length > 0
  #     $("button#start-recording").removeAttr("disabled")
  #   else
  #     $("button#start-recording").attr("disabled", "disabled")

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
    $("#step-count a").unbind("click")
    # unbind select element buttons
    $("button#start-text-highlight").unbind("click", AutoTestEvent.bindLink)

  $("#stop-recording").click ->
    $(".recording-bar").removeClass("recording")
    $("select#features").removeAttr("disabled").show()
    $("button#add-feature").show()
    $("#current-scenario").hide().html('')
    $("button#record").removeAttr("disabled")
    $("#step-count-text").hide()
    $("#step-count").text('')
    $("#step-count").hide()
    $("#view-steps").slideUp()
    $("#view-steps ul").html("")
    recorder = window.autoTestRecorder
    recorder.stop()
    $("#stop-recording").hide()
    $("#start-text-highlight").hide()
    $("#record").show()

  # Text highlighting
  $("button#start-text-highlight").click (e)->
    e.preventDefault()
    e.stopPropagation()
    $(this).hide()
    $("button#stop-record-text-highlight").show()
    #unbind stop recording element selection button
    $("button#stop-record-text-highlight").unbind("click", AutoTestEvent.bindLink)

    $("body *").hover(autoTestGuiController.hoverOutline)
    $("html").unbind("mouseenter").unbind("mouseleave")
    $("*").css('cursor', 'crosshair')

    # Recording bar cursor not changing
    $("#recording-bar *").css("cursor", "auto")

    # Unbind links and prevent default
    $("a").unbind("click", AutoTestEvent.bindLink)
    $("a, button, input[type='submit'], select").bind("click", autoTestGuiController.preventClicks)

    # Unbind hover for body and modal backdrop
    $("body").unbind("hover", autoTestGuiController.hoverOutline)
    $(".modal-backdrop").unbind("hover", autoTestGuiController.hoverOutline)

    # Bind click for all elements in a page
    $("body *").bind('click', autoTestGuiController.bindBodyClick)

    # Unbind recording bar
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
    $("a").bind("click", AutoTestEvent.bindLink)

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

  $("#step-count").click (e) ->
    if $("#view-steps").is(':visible')
      $("#view-steps").slideUp()
    else
      $("#view-steps").slideDown()

AutoTestGuiController = {

  unbindAutoTestBar: ->
    $("div.recording-bar").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar *").unbind("mouseenter").unbind("mouseleave")
    $("div.recording-bar").unbind('click', autoTestGuiController.bindBodyClick)
    $("div.recording-bar *").unbind('click', autoTestGuiController.bindBodyClick)
    $("div.recording-bar *").click (e) ->
      e.stopPropagation()

    return


  hoverOutline: (event) ->
    event.stopPropagation
    $("*").removeClass("autotest-highlight")
    # Convert this to a class.
    $(this).addClass("autotest-highlight")
    $(this).mouseleave (e) ->
      e.stopPropagation()
      $(this).removeClass("autotest-highlight")
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

    element_html = AutoTestGuiController.stripStyleClass($(element))
    $("#record-element-html").text($(element_html).clone().wrap("<p>").parent().html())
    $("#record_text_element_html").val($(element_html).clone().removeAttr("style").wrap("<p>").parent().html())
    $("#recording-bar *").click (e) ->
      e.stopPropagation()

    $(".close-element-modal").bind 'click', (e) ->
      e.stopPropagation()
      $("#element-modal").modal('hide')
    $(".validation-radio").click ->
      $("#save-validation").removeAttr('disabled', false)
    $("#save-validation").bind 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      checked = $("input[name=record_text]:checked")
      type = if checked.attr("id") is "record_text_text" then "verifyText" else "verifyElementPresent"
      autoTestRecorder.currentScenario.addStep(type, {type: '', value: ''}, checked.val())
      $("#element-modal").modal("hide")
    return

  stripStyleClass: ($element) ->
    $element.removeClass("autotest-highlight")
    style = $element.attr("style")
    $element.attr("style", style.replace(/\s?cursor:\s?crosshair;/, ""))
    if $element.attr("class").length is 0
      $element.removeAttr("class")
    if $element.attr("style").length is 0
      $element.removeAttr("style")
    return $element

  startRecording: (recorder) ->
    $("select#features").attr("disabled", "disabled")
    $("select#features").hide()
    $("button#add-feature").hide()
    $("#current-scenario").html("<strong>Currently recording: #{recorder.currentFeature.name} - #{recorder.currentScenario.name}</strong>").show()
    $("button#record").hide()
    $("button#stop-recording").show()
    $("#step-count").show()
    $(".recording-bar").addClass("recording")
    $("button#start-text-highlight").show()
    $("#step-count-text").show()

  showScenarioModal: (event) ->
    css = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto"}
    window.parent.renderModal("#add-scenario", '', css, ->
      console.log($("input#scenario_name"))
      $("input#scenario_name").bind "blur", ->
        if $(this).val().length > 0
          $("button#start-recording").removeAttr("disabled")
        else
          $("button#start-recording").attr("disabled", "disabled")
      return
    )
    return

  bindBodyClick: (event) ->
    event.preventDefault()
    event.stopPropagation()
    console.log("Showign element modal")
    autoTestGuiController.showElementModal(event, event.currentTarget)

  preventClicks: (event) ->
    event.preventDefault
    return false

  enableTooltip: () ->
    $("#record-button-wrapper").tooltip("enable")

  disableTooltip: () ->
    $("#record-button-wrapper").tooltip("disable")
}

window.autoTestGuiController = AutoTestGuiController
