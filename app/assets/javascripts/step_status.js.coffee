iconTemplate = (status) ->
  if status is "pass"
    return "<span class='glyphicon glyphicon-ok-sign status status-pass'></span>&nbsp;"
  else
    return "<span class='glyphicon glyphicon-exclamation-sign status status-fail'></span>&nbsp;"

statusTemplate = _.template("<li><%= status_icon %><%= text %></li>")

scenarioTemplate = _.template("<p id='<%= test.platform %>-<%= test.browser %>-scenario-<%= scenario_id %>'>Scenario: <%= scenario_name %></p>
                               <ul class='steps-list' id='<%= channel_name %>-scenario-steps-<%= scenario_id %>'></ul>")
featureTemplate = _.template("<p id='<%= channel_name %>-feature-<%= feature_id %>'>Feature: <%= feature_name %></p><br /><br />")

selectedBrowsers = ->
  browsers = []
  _.each $("form.scenario-run input[type='checkbox']"), (input) ->
    browsers.push($(input).val()) if $(input).is(":checked")
  return browsers

$(document).ready ()->
  if(completed? && completed == false)
    window.durationCounter = setInterval (->
      seconds = ++sec % 60
      minutes = parseInt(sec / 60, 10)
      $("#duration").html("#{minutes}m #{seconds}s")
      return
    ), 1000

  bindTestChannels()

  $("input[type='checkbox']").on "change", () ->
    switchRunTestButton(this)

switchRunTestButton = (el)->
  button = $(el).closest("form.scenario-run").find("input.run-test")
  concurrencyLimit = parseInt $(".concurrency-limit").text()
  numChecked = $(el).closest("form.scenario-run").find("input:checked").length

  if numChecked > concurrencyLimit
    button.attr("disabled", true)
    button.siblings(".concurrency-warning").removeClass("hide")
  else if $(el).closest("form.scenario-run").find("input:checked").length > 0
    button.siblings(".concurrency-warning").addClass("hide")
    button.removeAttr("disabled")
  else
    button.attr("disabled", true)

showPanels = (scenario_id)->
  $("#scenario_panel_#{scenario_id}").show()
  _.each window.channels, (channel) ->
    $("##{channel.name}").parent().show()
