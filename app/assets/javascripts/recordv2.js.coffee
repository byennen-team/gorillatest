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

selectElementModalTemplate = _.template '<div class="modal-content" style="cursor: auto; outline: none;">
                              <div class="modal-header" style="cursor: auto; outline: none;">
                              <button class="close close-element-modal" data-dismiss="modal" style="cursor: auto; outline: none;">×</button>
                              <h4 style="cursor: auto; outline: none;">Choose Validation</h4>
                              </div>
                              <div class="modal-body" style="cursor: auto; outline: none;">
                              <input class="validation-radio" id="record_text_text" name="record_text" type="radio" value="Test Form" style="cursor: auto; outline: none;">
                              <label style="cursor: auto; outline: none;">
                              Record element text:
                              </label>
                              <p id="record-element-text" style="cursor: auto; outline: none;"></p>
                              <br style="cursor: auto; outline: none;">
                              <input class="validation-radio" id="record_text_element_html" name="record_text" type="radio" value="&lt;h1&gt;Test Form&lt;/h1&gt;" style="cursor: auto; outline: none;">
                              <label style="cursor: auto; outline: none;">
                              Record element:
                              </label>
                              <p id="record-element-html" style="cursor: auto; outline: none;"></p>
                              </div>
                              <div class="modal-footer" style="cursor: auto; outline: none;">
                              <button class="btn btn-default close-element-modal" data-dismiss="modal" style="cursor: auto; outline: none;">Close</button>
                              <button class="btn btn-primary" disabled="disabled" id="save-validation" style="cursor: auto; outline: none;">Save Validation</button>
                              </div>
                              </div>'

addFeatureModalTemplate = _.template '<div class="modal-content">
                                    <div class="modal-header">
                                      <button class="close" data-dismiss="modal">×</button>
                                      <h4>Create a new Feature</h4>
                                    </div>
                                    <div class="modal-body">
                                      <label>Feature Name</label>
                                      <input id="feature_name" name="feature[name]" type="text">
                                    </div>
                                    <div class="modal-footer">
                                      <button class="btn btn-default" data-dismiss="modal">Close</button>
                                      <button class="btn btn-primary" disabled="disabled" id="create-feature">Create Feature</button>
                                    </div>
                                  </div>'


# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->
  iframeWrapper = document.createElement("DIV")
  iframeWrapper.id = "iframe-wrapper"
  iframeWrapper.style.position = "fixed"
  iframeWrapper.style.width = "100%"
  iframeWrapper.style.zIndex = "2000"

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

  document.body.insertBefore(iframeWrapper, iframeBottomMargin)

  steps = document.createElement("DIV")
  steps.id = "autotest-view-steps"
  stepsList = document.createElement("UL")
  stepsList.id = "autotest-steps"
  steps.appendChild(stepsList)
  steps.style.display = "none"
  document.body.appendChild(steps)

  styleSheetUrl = window.apiUrl + "/assets/application/recorder.css"
  $('head').append("<link rel='stylesheet' type='text/css' href='"+ styleSheetUrl + "'>");


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
      when "addFeature"
        autoTestGuiController.showFeatureModal()
      when "viewSteps"
        autoTestGuiController.viewSteps()
      when "stopRecording"
        autoTestRecorder.stop()
      when "selectElement"
        autoTestGuiController.startElementHighlight()
      when "stopSelectElement"
        autoTestGuiController.stopElementHighlight()

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

  window.renderModal = (template, html, options) ->
    parent = "body"
    options = options or {}
    options.width = options.width or "auto"
    $content = $(eval(template)())
    if $("##{options.wrapperId}").length == 1
      $wrapper = $("##{options.wrapperId}")
      $("##{options.wrapperId}").html($content)
    else
      $wrapper = $("<div class='autotest-modal modal hide' id='#{options.wrapperId}'></div>")
      $content.appendTo($wrapper)

    $this = $wrapper.appendTo(parent)
    $this.modal()

    $this.removeClass("hide")
    # $this.css
    #   "max-width": options.width
    #   height: options.height
    #   margin: options.margin
    #   "overflow-y": options["overflow-y"]

    autoTestGuiController.verifyInputNamePresent(options.wrapperId)

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



  # $(".recording-bar .modal").on "hidden.bs.modal", (e) ->
  #   $(this).css("height", "0px").css("overflow-y", "hidden")
