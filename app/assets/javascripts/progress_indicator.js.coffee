window.iconTemplate = (status) ->
  if status is "pass"
    return "<span class='glyphicon glyphicon-ok-sign status status-pass'></span>&nbsp;"
  else
    return "<span class='glyphicon glyphicon-exclamation-sign status status-fail'></span>&nbsp;"
window.statusTemplate = _.template("<li><%= status_icon %><%= text %></li>")
window.scenarioTemplate = _.template("<p id='<%= test.platform %>-<%= test.browser %>-scenario-<%= scenario_id %>'>
                                      Test: <%= scenario_name %> (<span class='steps-completed'>0</span> of <%= num_total_steps %> completed)</p>
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
    if !$(".alert").hasClass("alert-no-fade")
      $(".alert").fadeOut(800)

  $(".alert").bind 'click', (ev) =>
    $(".alert").fadeOut(800)

  setTimeout flashCallback, 3000

  bindApplicationChannels()
