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

pusher = new Pusher("752bdfea8277bb7d911e")
channels = []
window.channels = channels

$(document).ready ()->
  $("input[type='checkbox']").on "change", () ->
    button = $(this).closest("form.scenario-run").find("input.run-test")
    if $(this).closest("form.scenario-run :checked").length > 0
      button.removeAttr("disabled")
    else
      button.attr("disabled", true)

  $("form.scenario-run").on 'submit', (e)->
    browsers = selectedBrowsers()
    e.preventDefault()
    # debugger
    that = this
    _.each $("form.scenario-run input[type='checkbox']"), (input) ->
      console.log($("form.scenario-run input[type='checkbox']").length)
      if $(input).is(":checked")
        window.channels.push(pusher.subscribe("#{$(that).attr('id')}_#{$(input).val()}_channel"))
    console.log(that)
    $.ajax
      url: $(that).attr('action')
      method: "POST"
      data: {browsers: browsers}
      success: (data)->
        bindChannels()
        showPanels($(that).attr('action').match(/\/scenarios\/(.*)\/run/)[1])
        console.log("form submitted")

bindChannels = ()->
  _.each window.channels, (channel)->
    console.log("BINDING")
    console.log(channel)
    channel.bind "step_pass", (data) ->
      console.log data.message
      console.log("appending to #{channel.name}")
      data.message.status_icon = iconTemplate(data.message.status)
      if data.message.event_type != "verifyElementPresent" && data.message.event_type != "verifyText"
        $("##{channel.name} ul").append(statusTemplate(data.message))
      else
        $("##{channel.name} ul").append("<li>#{iconTemplate(data.message.status)}<span class='to-s'></span></li>")
        $("##{channel.name} ul li").last().find('span.to-s').text($('<div/>').html(data.message.to_s).wrap("<p>").parent().html().replace(/<div>/,"").replace(/<\/div>/,""))

      if data.message.status is "fail"
        $("##{channel.name}").prev().removeClass("panel-success").addClass("panel-fail")
      else
        $("##{channel.name}").prev().addClass("panel-success")


showPanels = (scenario_id)->
  $("#scenario_panel_#{scenario_id}").show()
  _.each window.channels, (channel) ->
    $("##{channel.name}").parent().show()
