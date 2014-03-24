//= require jquery
//= require bootstrap
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require autotest/gui_controller
//= require autotest/autotest
#//= require autotest/templates/add_feature_modal.jst
#//= require_tree ./autotest/templates
//= require_tree ./autotest/models
//= require_tree ./autotest/collections
//= require_tree ./autotest/views
//= require_tree ./autotest/routers

# //= require autotest/recorder
# //= require autotest/feature
# //= require autotest/scenario
# //= require autotest/step
# //= require autotest/event
# //= require autotest/locator_builder
# //= require autotest/locator
# //= require autotest/gui_controller
# //= require autotest/iframe_message_handler
# //= require autotest/iframe_controller

# scripts = document.getElementsByTagName("script")
# i = 0
# l = scripts.length

# while i < l
#   if (/iframe/).test(scripts[i].src)
#     window.projectId = scripts[i].getAttribute("data-project-id")
#     window.authToken =  scripts[i].getAttribute("data-auth")
#     if scripts[i].getAttribute("data-api-url")
#       window.apiUrl = scripts[i].getAttribute("data-api-url")
#     else
#       window.apiUrl = "http://autotest.io"
#     break
#   i++

addEventListener "message", (e)->
  data = e.data
  IframeMessageHandler.perform(data.messageType, data)

