window.autoTestTemplates = {}

AutoTestGuiController = {

  removeStepsList: ->
    $("#autotest-view-steps").slideUp()
    $("ul#autotest-steps").html("")

  verifyInputNamePresent: (modal)->
    $("#scenario_name, #feature_name").on 'keyup', ->
      if $(this).val().length > 0
        if modal == "feature-modal"
          $("#create-feature").removeAttr("disabled")
        else
          $("#start-recording").removeAttr("disabled")
      else
        if modal == "feature-modal"
          $("#create-feature").attr("disabled", "disabled")
        else
          $("#start-recording").attr("disabled", "disabled")

  viewSteps: ->
    if $("#autotest-view-steps").is(':visible')
      $("#autotest-view-steps").slideUp()
    else
      $("#autotest-view-steps").slideDown()

  showFeatureModal: ->
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'feature-modal'}
    renderModal("add_feature_modal", options)
    AutoTestGuiController.createFeature()

  # Let's come back to this.  We should move the AJAX call to the
  # feature.js.coffee
  createFeature: ->
    $("button#create-feature").click (e) ->
      e.preventDefault()
      e.stopPropagation()
      # project_id = location.search.split('project_id=')[1]
      data = { feature: {name: $("#feature_name").val()} }

      $.ajax "#{window.apiUrl}/api/v1/features",
        type: "POST"
        data: data
        async: false
        beforeSend: (xhr, settings) ->
          xhr.setRequestHeader('Authorization', "Token token=\"#{window.authToken}\"")
        success: (data) ->
          $("#feature-modal").bPopup().close()
          $("#feature_name").val('')
          feature = data.feature
          window.postMessageToIframe({messageType: "featureAdded", message: {featureName: feature.name, featureId: feature.id}})
          window.autoTestRecorder.setCurrentFeature(feature.id)
        error:  (jqXHR, textStatus, errorThrown) ->
          if $("#feature-modal-errors").length == 0
            $("#feature-modal .autotest-modal-body").append("<ul id='feature-modal-errors'></ul>")
          $("#feature-modal-errors").html('')
          $.each jqXHR.responseJSON.errors, (i, message) ->
            $("#feature-modal-errors").append("<li class='text-danger'>#{message}</li>")

  startRecording: ->
    event.preventDefault()
    recorder = window.autoTestRecorder
    scenario = recorder.addScenario($("input#scenario_name").val())
    if scenario.status == "success"
      recorder.record()
      $("#scenario-modal").bPopup().close()
      recorder.currentScenario.addStep("get", {type: '', value: ''}, window.location.href)
      window.postMessageToIframe({messageType: "startRecording", message: {scenarioName: autoTestRecorder.currentScenario.name, featureName: autoTestRecorder.currentFeature.name}})
    else
      if $("#scenario-modal-errors").length == 0
        $("#scenario-modal .autotest-modal-body").append("<ul id='scenario-modal-errors'></ul>")
      $("#scenario-modal-errors").html('')
      $.each scenario.errors, (i, message) ->
        $("#scenario-modal-errors").append("<li class='text-danger'>#{message}</li>")

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
    $("body *").hover(autoTestGuiController.hoverOutline)
    $("html").unbind("mouseenter").unbind("mouseleave")
    $("*").css('cursor', 'crosshair')

    # Unbind links and prevent default
    $("a").unbind("click", AutoTestEvent.bindClick)
    $("a, button, input[type='submit'], select").bind("click", autoTestGuiController.preventClicks)

    # Unbind hover for body and modal backdrop
    $("body").unbind("hover", autoTestGuiController.hoverOutline)
    $(".modal-backdrop").unbind("hover", autoTestGuiController.hoverOutline)

    # Bind click for all elements in a page
    $("body *").bind('mousedown', autoTestGuiController.bindBodyClick)

    # Unbind recording bar
    $("iframe").unbind("mouseenter").unbind("mouseleave")

  stopElementHighlight: (e) ->
    $('body').unbind('mouseup')
    $("*").css('cursor', 'auto')
    $("body *").unbind("mousedown", AutoTestGuiController.bindBodyClick)
    $("body *").unbind("mouseenter").unbind("mouseleave")
    $("a, button, input[type='submit'], select").unbind("click", autoTestGuiController.preventClicks)
    $("a").bind("click", AutoTestEvent.bindClick)

  showElementModal: (event, element) ->
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'select-element-modal'}
    renderModal("select_element_modal", options)
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
      $("#select-element-modal").bPopup().close()
    $(".validation-radio").click ->
      $("#save-validation").removeAttr('disabled', false)
    $("#save-validation").bind 'click', (e) ->
      e.preventDefault()
      e.stopPropagation()
      checked = $("input[name=record_text]:checked")
      type = if checked.attr("id") is "record_text_text" then "verifyText" else "verifyElementPresent"
      autoTestRecorder.currentScenario.addStep(type, {type: '', value: ''}, checked.val())
      $("#select-element-modal").bPopup().close()
    return false

  stripStyleClass: ($element) ->
    $element.removeClass("autotest-highlight")
    style = $element.attr("style")
    $element.attr("style", style.replace(/\s?cursor:\s?crosshair;/, "")) if style
    if $element.attr("class") != undefined && $element.attr("class").length == 0
      $element.removeAttr("class")
    if $element.attr("style") != undefined && $element.attr("style").length == 0
      $element.removeAttr("style")
    return $element

  bindBodyClick: (event) ->
    event.preventDefault()
    event.stopPropagation()
    autoTestGuiController.showElementModal(event, event.currentTarget)
    return false

  preventClicks: (event) ->
    event.preventDefault
    return false

  renderModal: (templateName, options) ->
    parent = "body"
    options = options or {}
    options.width = options.width or "auto"
    $content = $(autoTestTemplates["autotest/templates/#{templateName}"]())
    if $("##{options.wrapperId}").length == 1
      $wrapper = $("##{options.wrapperId}")
      $("##{options.wrapperId}").html($content)
    else
      $wrapper = $("<div class='autotest-modal' id='#{options.wrapperId}'></div>")
      $content.appendTo($wrapper)

    $this = $wrapper.appendTo(parent)
    $this.removeClass("hide")

    $this.bPopup
      onOpen: ()->
        input = $this.find("input")
        if $this.find("button#create-feature").length == 1
          button = $this.find("button#create-feature")
        else
          button = $this.find("button#start-recording")
        $(input).keypress (e)->
          e.stopPropagation()
          if e.which == 13 && $(button).attr("disabled") != "disabled"
            $(button).trigger("click")
      onClose: ()->
        input = $this.find("input")
        $(input).unbind("blur")
        $(input).unbind("keypress")

    $(".autotest-modal-close, .autotest-modal-close-x").click ->
      $(this).closest(".autotest-modal").bPopup().close()

    autoTestGuiController.verifyInputNamePresent(options.wrapperId)

    $("#start-recording").click ->
      window.autoTestGuiController.startRecording()
    return

}

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
    $("body *").unbind("mousedown", AutoTestGuiController.bindBodyClick)
    $("body *").unbind("mouseenter").unbind("mouseleave")
    $("a, button, input[type='submit'], select").unbind("click", autoTestGuiController.preventClicks)
    $("a").bind("click", AutoTestEvent.bindClick)

window.autoTestGuiController = AutoTestGuiController
