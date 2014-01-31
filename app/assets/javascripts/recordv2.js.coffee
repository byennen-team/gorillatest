//= require autotest/recorder
//= require autotest/feature
//= require autotest/scenario
//= require autotest/step
//= require autotest/event
//= require autotest/locator_builder
//= require autotest/locator
//= require gui_controller
//= require underscore
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

scenarioModalTemplate = _.template '<div class="modal-content">
          <div class="modal-header">
            <button class="close" data-dismiss="modal">×</button>
            <h4>Start Recording A New Scenario</h4>
          </div>
          <div class="modal-body">
            <label>Scenario Name</label>
            <input id="scenario_name" name="scenario[name]" type="text">
            <p>Once this modal closes AutoTest will automatically start recording your behavior for this scenario</p>
          </div>
          <div class="modal-footer">
            <button class="btn btn-default" data-dismiss="modal">Close</button>
            <button class="btn btn-primary" disabled="disabled" id="start-recording">Start Recording</button>
          </div>
        </div>'

# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->
  iframe = document.createElement("IFRAME")
  iframe.setAttribute("src", "http://localhost:4000/recorder?project_id=#{window.projectId}")
  iframe.id = "autotest-iframe"
  iframe.style.width = "100%"
  iframe.style.height = "75px"
  iframe.style.top = "0px"
  iframe.onload = '$("iframe").contents().find("input#scenario_name").on("keyup", function() {console.log("WOFIJ");if ($(this).val().length > 0) {return $("button#start-recording").removeAttr("disabled");} else {return $("button#start-recording").attr("disabled", "disabled");}});'
  document.body.insertBefore(iframe, document.body.firstChild)
  steps = document.createElement("DIV")
  steps.id = "autotest-view-steps"
  stepsList = document.createElement("UL")
  stepsList.id = "autotest-steps"
  steps.appendChild(stepsList)
  steps.style.display = "none"
  document.body.appendChild(steps)


  window.autoTestRecorder = new AutoTestRecorder window.projectId
  window.autoTestApiUrl = window.apiUrl
  window.autoTestAuthToken = window.authToken

  window.addEventListener "message", (e)->
    data = e.data
    switch data.messageType
      when "setFeature"
        autoTestRecorder.setCurrentFeature(data.featureId)
      when "recordClick"
        autoTestGuiController.showScenarioModal()
      when "viewSteps"
        debugger
        autoTestGuiController.viewSteps()

  postMessageToIframe = (message)->
    console.log("posting")
    iframe = document.getElementById("autotest-iframe").contentWindow
    iframe.postMessage(message, window.apiUrl)

  window.postMessageToIframe = postMessageToIframe

  console.log("authtoken is #{window.autoTestAuthToken}")
  if $(".test-form").length > 0
    $(".test-form").attr("action", "/test/form_post?project_id=#{window.projectId}")
  autoTestRecorder.start()

  options = new Array
  $.each autoTestRecorder.features, (k, v) ->
    options.push "<option value='#{v.id}'>#{v.name}</option>"
  $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
  $("select#features").bind "change", ->
    window.autoTestRecorder.setCurrentFeature($(this).val()) if $(this).val().length > 0

  window.renderModal = (selector, html, options, callback) ->
    parent = "body"
    $this = $(parent).find(selector)
    options = options or {}
    options.width = options.width or "auto"
    if $this.length is 0
      console.log("loading parent")
      $content = $(scenarioModalTemplate())
      if $("##{options.wrapperId}").length == 1
        $wrapper = $("##{options.wrapperId}")
        $("##{options.wrapperId}").html($content)
      else
        $wrapper = $("<div class='modal hide fade' id='#{options.wrapperId}'></div>")
        $content.appendTo($wrapper)

      $this = $wrapper.appendTo(parent)
      $this.modal()

    $this.removeClass("hide")
    $this.css
      "max-width": options.width
      height: options.height
      margin: options.margin
      "overflow-y": options["overflow-y"]

    autoTestGuiController.verifyScenarioNamePresent()

    $("#start-recording").click ->
      window.autoTestGuiController.startRecording()
    return
    # $("input#scenario_name").on "keyup", ->
    #   console.log("KYEUP")
    #   if $(this).val().length > 0
    #     $("button#start-recording").removeAttr("disabled")
    #   else
    #     $("button#start-recording").attr("disabled", "disabled")

  # $(".recording-bar .modal").on "show.bs.modal", (e) ->
    # $(this).css("height", "300px").css("overflow-y", "visible")



  $(".recording-bar .modal").on "hidden.bs.modal", (e) ->
    $(this).css("height", "0px").css("overflow-y", "hidden")
