//= require bPopup.min
//= require underscore
//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require autotest/event
//= require autotest/locator_builder
//= require autotest/locator
//= require autotest/gui_controller
//= require autotest/post_message_handler
//= require_tree ./autotest/templates/
//= require_self

scripts = document.getElementsByTagName("script")
i = 0
l = scripts.length

while i < l
  if (/recordv2/).test(scripts[i].src)
    window.projectId = scripts[i].getAttribute("data-project-id")
    window.authToken =  scripts[i].getAttribute("data-auth")
    if scripts[i].getAttribute("data-api-url")
    	window.apiUrl = scripts[i].getAttribute("data-api-url")
    else
    	window.apiUrl = "http://autotest.io"
    break
  i++


# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->
  iframeWrapper = document.createElement("DIV")
  iframeWrapper.id = "iframe-wrapper"
  iframeWrapper.style.position = "fixed"
  iframeWrapper.style.width = "100%"
  iframeWrapper.style.zIndex = "2000"
  iframeWrapper.style.top = "0px"
  iframeWrapper.style.left = "0px"

  iframe = document.createElement("IFRAME")
  iframe.setAttribute("src", "#{window.apiUrl}/recorder?project_id=#{window.projectId}")
  iframe.id = "autotest-iframe"
  iframe.style.width = "100%"
  iframe.style.height = "55px"
  iframe.style.top = "0px"
  iframe.style.border = "0px"
  iframe.style.display = "block"
  iframe.onload = '$("iframe").contents().find("input#scenario_name").on("keyup", function() {console.log("WOFIJ");if ($(this).val().length > 0) {return $("button#start-recording").removeAttr("disabled");} else {return $("button#start-recording").attr("disabled", "disabled");}});'
  iframeWrapper.appendChild(iframe)

  iframeBottomMargin = document.createElement("DIV")
  iframeBottomMargin.style.height = "55px"

  document.body.insertBefore(iframeBottomMargin, document.body.firstChild)

  document.body.insertBefore(iframeWrapper, document.body.firstChild)

  steps = document.createElement("DIV")
  steps.id = "autotest-view-steps"
  stepsList = document.createElement("UL")
  stepsList.id = "autotest-steps"
  steps.appendChild(stepsList)
  steps.style.display = "none"
  document.body.appendChild(steps)

  styleSheetUrl = window.apiUrl + "/assets/application/recorder.css"
  $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");

  overlay = document.createElement("DIV")
  overlay.id = "autotest-overlay"
  document.body.insertBefore(overlay, document.body.firstChild)

  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken

  window.addEventListener "message", (e)->
    data = e.data
    AutoTestPostMessageHandler.perform(data.messageType, data.featureId)

  postMessageToIframe = (message)->
    console.log("posting")
    iframe = document.getElementById("autotest-iframe").contentWindow
    iframe.postMessage(message, window.apiUrl)

  window.postMessageToIframe = postMessageToIframe

  autoTestRecorder.start()

  window.renderModal = (templateName, options) ->
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
