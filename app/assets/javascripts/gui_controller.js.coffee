$(document).ready ->

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

AutoTestGuiController = {
  iframeScopeFind: (element)->
    $("iframe").contents().find(element)

  verifyScenarioNamePresent: ->
    $("#scenario_name").on 'keyup', ->
      if $(this).val().length > 0
        $("#start-recording").removeAttr("disabled")
      else
        $("#start-recording").attr("disabled", "disabled")

  viewSteps: ->
    if $("#autotest-view-steps").is(':visible')
      $("#autotest-view-steps").slideUp()
    else
      $("#autotest-view-steps").slideDown()

  loadFeatures: ->
    options = new Array
    $.each window.autoTestRecorder.features, (k, v) ->
      options.push "<option value='#{v.id}'>#{v.name}</option>"
    @iframeScopeFind("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
    @iframeScopeFind("select#features").bind "change", ->
      window.autoTestRecorder.setCurrentFeature($(this).val()) if $(this).val().length > 0
    return

  startRecording: ->
    recorder = window.autoTestRecorder
    event.preventDefault()
    recorder.addScenario($("input#scenario_name").val())
    recorder.record()
    $("#scenario-modal").modal("hide")
    recorder.currentScenario.addStep("get", {type: '', value: ''}, window.location.href)
    window.postMessageToIframe({messageType: "startRecording", message: {scenarioName: autoTestRecorder.currentScenario.name, featureName: autoTestRecorder.currentFeature.name}})

    # unbind select element buttons
    # $("button#start-text-highlight").unbind("click", AutoTestEvent.bindLink)

  stopRecording: ->
    $(".recording-bar").removeClass("recording")
    $("select#features").removeAttr("disabled").show()
    # $("button#add-feature").show()
    $("#current-scenario").hide().html('')
    if $("#features").find(":selected").val()
      $("button#record").removeAttr("disabled")
      AutoTestGuiController.disableTooltip()
    else
      $("button#record").attr("disabled", "disabled")
      AutoTestGuiController.enableTooltip()

    $("#step-count-text").hide()
    $("#step-count").text('')
    $("#step-count").hide()
    $("#view-steps").slideUp()
    $("#view-steps ul").html("")
    $("#stop-recording").hide()
    $("#start-text-highlight").hide()
    $("#record").show()

  unbindAutoTestBar: ->
    $("iframe").unbind("mouseenter").unbind("mouseleave")
    # $("div.recording-bar").unbind("mouseenter").unbind("mouseleave")
    # $("div.recording-bar *").unbind("mouseenter").unbind("mouseleave")
    # $("div.recording-bar").unbind('click', autoTestGuiController.bindBodyClick)
    # $("div.recording-bar *").unbind('click', autoTestGuiController.bindBodyClick)
    # $("div.recording-bar *").click (e) ->
    #   e.stopPropagation()

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

  startElementHighlight: (e)->
    # e.preventDefault()
    # e.stopPropagation()
    #unbind stop recording element selection button
    # $("button#stop-record-text-highlight").unbind("click", AutoTestEvent.bindLink)

    $("body *").hover(autoTestGuiController.hoverOutline)
    $("html").unbind("mouseenter").unbind("mouseleave")
    $("*").css('cursor', 'crosshair')

    # Recording bar cursor not changing
    # $("#recording-bar *").css("cursor", "auto")

    # Unbind links and prevent default
    $("a").unbind("click", AutoTestEvent.bindLink)
    $("a, button, input[type='submit'], select").bind("click", autoTestGuiController.preventClicks)

    # Unbind hover for body and modal backdrop
    $("body").unbind("hover", autoTestGuiController.hoverOutline)
    $(".modal-backdrop").unbind("hover", autoTestGuiController.hoverOutline)

    # Bind click for all elements in a page
    $("body *").bind('click', autoTestGuiController.bindBodyClick)

    # Unbind recording bar

  stopElementHighlight: (e) ->
    # e.preventDefault()

    $('body').unbind('mouseup')
    $("*").css('cursor', 'auto')

    $("body *").unbind("click", AutoTestGuiController.bindBodyClick)
    $("body *").unbind("mouseenter").unbind("mouseleave")
    $("a, button, input[type='submit'], select").unbind("click", autoTestGuiController.preventClicks)
    $("a").bind("click", AutoTestEvent.bindLink)

  showElementModal: (event, element) ->
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'select-element-modal'}
    window.renderModal("selectElementModalTemplate", '', options)
    $("#select-element-modal *").css('cursor', 'auto')
    $("#select-element-modal *").css("outline", "none")
    $("#select-element-modal *").unbind("mouseenter").unbind("mouseleave")
    $("#select-element-modal").unbind("click")
    $("#select-element-modal *").unbind("click")
    $("#record-element-text").html($(element).text())
    $("#record_text_text").val($(element).text())

    element_html = AutoTestGuiController.stripStyleClass($(element))
    $("#record-element-html").text($(element_html).clone().wrap("<p>").parent().html())
    $("#record_text_element_html").val($(element_html).clone().wrap("<p>").parent().html())
    $("#recording-bar *").click (e) ->
      e.stopPropagation()

    $(".close-element-modal").bind 'click', (e) ->
      e.stopPropagation()
      $("#select-element-modal").modal('hide')
    $(".validation-radio").click ->
      $("#save-validation").removeAttr('disabled', false)
    $("#save-validation").bind 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      checked = $("input[name=record_text]:checked")
      type = if checked.attr("id") is "record_text_text" then "verifyText" else "verifyElementPresent"
      autoTestRecorder.currentScenario.addStep(type, {type: '', value: ''}, checked.val())
      $("#select-element-modal").modal("hide")
    return

  stripStyleClass: ($element) ->
    $element.removeClass("autotest-highlight")
    style = $element.attr("style")
    $element.attr("style", style.replace(/\s?cursor:\s?crosshair;/, "")) if style
    if $element.attr("class") != undefined && $element.attr("class").length == 0
      $element.removeAttr("class")
    if $element.attr("style") != undefined && $element.attr("style").length == 0
      $element.removeAttr("style")
    return $element

  recording: (message) ->
    $("#current-scenario").text("Currently recording #{message.featureName} - #{message.scenarioName}")
    $("button#record").hide()
    $("button#stop-recording").show()
    $("#start-text-highlight").show()
    $("select#features").attr("disabled", "disabled")
    $("select#features").hide()
    # $("button#add-feature").hide()
    $("#step-count").show()
    $(".recording-bar").addClass("recording")
    $("#step-count-text").show()

  showScenarioModal: (event) ->
    console.log("show scenario")
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'scenario-modal'}
    window.parent.renderModal("scenarioModalTemplate", '', options, ->
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

  enableRecordButton: ->
    if $("select#features").val().length > 0
      $("button#record").removeAttr("disabled")
      AutoTestGuiController.disableTooltip()
    else
      $("#record").attr("disabled", "disabled")
      AutoTestGuiController.enableTooltip()

  enableTooltip: () ->
    $("#record-button-wrapper").tooltip("enable")

  disableTooltip: () ->
    $("#record-button-wrapper").tooltip("disable")
}

window.autoTestGuiController = AutoTestGuiController
