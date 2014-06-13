//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require userFlow
//= require plugins/jquery.validate.min
//= require plugins/jquery.easing.min
//= require layout/shortcuts
//= require layout/left_panel
//= require project
//= require messages
//= require pusher

window.iconTemplate = (status) ->
  if status is "pass"
    return "<span class='glyphicon glyphicon-ok-sign status status-pass'></span>&nbsp;"
  else
    return "<span class='glyphicon glyphicon-exclamation-sign status status-fail'></span>&nbsp;"
window.statusTemplate = _.template("<li><%= status_icon %><%= text %></li>")
window.scenarioTemplate = _.template("<p id='<%= test.platform %>-<%= test.browser %>-scenario-<%= scenario_id %>'>
                                      Scenario: <%= scenario_name %> (<span class='steps-completed'>0</span> of <%= num_total_steps %> completed)</p>
                                     <ul class='steps-list' id='<%= channel_name %>-scenario-steps-<%= scenario_id %>'></ul>")
window.featureTemplate = _.template("<p id='<%= channel_name %>-feature-<%= feature_id %>'>Feature: <%= feature_name %></p><br /><br />")

$ ->
  target = window.location.hash
  if target != ""
    $("a[href='" + target + "']").tab("show")

  $("#user_role").change( ->
    console.log($(this).val())
    if $(this).val() == "Other"
      $("#role_other").show()
    else
      $("#role_other").hide()
  )
  $("#welcome button.close").click( ->
    $("#welcome").slideUp()
  )

  flashCallback = ->
    $(".alert").fadeOut(800)

  $(".alert").bind 'click', (ev) =>
    $(".alert").fadeOut(800)

  setTimeout flashCallback, 3000

  bindApplicationChannels()
