try
  Pusher.log = (message) ->
    window.console.log message  if window.console and window.console.log
catch error

channels = []
window.channels = channels

@bindTestChannels = ()->
  _.each window.channels, (channel)->
    channel.bind "test_run_complete", (data) ->
      if (data.status == "fail")
        className = "label-danger"
        text = "Failed"
      else
        className = "label-success"
        text = "Passed"
      $("#test-run-status").text(text)
      $("#test-run-status").removeClass("label-warning").addClass(className)
      if(completed? && completed == false)
        clearInterval(durationCounter)
    channel.bind "slot_unavailable", (data) ->
      data.channel_name = channel.name
      $("##{channel.name} .panel-body").append(data)
      alert(data)
    channel.bind "play_feature", (data) ->
      data.channel_name = channel.name
      $("##{channel.name} .panel-body").append(featureTemplate(data))
      return
    channel.bind "play_scenario", (data) ->
      data.channel_name = channel.name
      $("##{channel.name} .panel-body").append(scenarioTemplate(data))
      return
    channel.bind "step_pass", (data) ->
      data.status_icon = iconTemplate(data.status)
      steps_list_id = "#{channel.name}-scenario-steps-#{data.scenario_id}"
      $("##{steps_list_id}").append(statusTemplate(data))

      if data.status is "fail"
        $("##{channel.name}").prev().removeClass("panel-success").addClass("panel-fail")
      else
        $("##{channel.name}").prev().addClass("panel-success")
      return

messageTemplate = _.template("<li id='message_<%= id %>'><a href='<%= url %>' data-message-id='<%= id %>'><%= message %></a></li>")

@bindApplicationChannels = ->
  _.each window.applicationChannels, (channel) ->
    channel.bind "new_message", (data) ->
      currentNum = parseInt($("#unread_message_count").text()) || 0
      $("#unread_message_count").show()
      $("li#no_unread_messages").hide()
      $("#unread_message_count").text(currentNum + 1)
      $("ul#messages").prepend(messageTemplate(data))
      $("li#message_#{data.id} a").click (e) ->
        window.messageClickBehavior($(this), e)
