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
    $("a").unbind("click", Autotest.Event.bindClick)
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
    $("a").bind("click", Autotest.Event.bindClick)

  showElementModal: (event, element) ->
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'select-element-modal'}
    AutoTestGuiController.renderModal("select_element_modal", options)
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
      Autotest.currentScenario.addStep({event_type: type, locator_type: '', locator_value: '', text: checked.val()})
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
    $content = $(JST["autotest/templates/#{templateName}"]())
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
    $("a").bind("click", Autotest.Event.bindClick)

window.autoTestGuiController = AutoTestGuiController
