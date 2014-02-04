iconTemplate = (status) ->
  if status is "pass"
    return "<span class='glyphicon glyphicon-ok-sign status status-pass'></span>&nbsp;"
  else
    return "<span class='glyphicon glyphicon-exclamation-sign status status-fail'></span>&nbsp;"

statusTemplate = _.template("<li><%= status_icon %><%= to_s %></li>")

selectedBrowsers = ->
  browsers = []
  _.each $("form.scenario-run input[type='checkbox']"), (input) ->
    browsers.push($(input).val()) if $(input).is(":checked")
  return browsers

Pusher.log = (message) ->
  window.console.log message  if window.console and window.console.log

channels = []
window.channels = channels

$(document).ready ()->
  bindChannels()
  $("input[type='checkbox']").on "change", () ->
    button = $(this).closest("form.scenario-run").find("input.run-test")
    if $(this).closest("form.scenario-run").find("input:checked").length > 0
      button.removeAttr("disabled")
    else
      button.attr("disabled", true)

bindChannels = ()->
  _.each window.channels, (channel)->
    console.log("BINDING " + channel)
    channel.bind "step_pass", (data) ->
      console.log data.message
      console.log("appending to #{channel.name}")
      data.message.status_icon = iconTemplate(data.message.status)
      $("##{channel.name} ul").append(statusTemplate(data.message))

      if data.message.status is "fail"
        $("##{channel.name}").prev().removeClass("panel-success").addClass("panel-fail")
        alert("An error has been added to the Github project - bigastronaut/autotest")
      else
        $("##{channel.name}").prev().addClass("panel-success")


showPanels = (scenario_id)->
  $("#scenario_panel_#{scenario_id}").show()
  _.each window.channels, (channel) ->
    $("##{channel.name}").parent().show()
