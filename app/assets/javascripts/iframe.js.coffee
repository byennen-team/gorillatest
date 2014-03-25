//= require jquery
//= require bootstrap
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require autotest/gui_controller
//= require autotest/autotest
//= require_tree ./autotest/templates
//= require_tree ./autotest/models
//= require_tree ./autotest/collections
//= require_tree ./autotest/views
//= require_tree ./autotest/routers
//= require ./autotest/iframe_message_handler
//= require ./autotest/iframe_controller

addEventListener "message", (e)->
  data = e.data
  IframeMessageHandler.perform(data.messageType, data)

