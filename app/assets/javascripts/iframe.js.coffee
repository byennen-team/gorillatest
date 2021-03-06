//= require jquery
//= require bootstrap
//= require underscore
//= require ./plugins/jquery.purl.js
//= require backbone
//= require backbone_rails_sync
//= require autotest/gui_controller
//= require autotest/autotest
//= require_tree ./autotest/templates
//= require_tree ./autotest/models
//= require_tree ./autotest/collections
//= require_tree ./autotest/views
//= require_tree ./autotest/routers
//= require ./autotest/messages/iframe
//= require ./autotest/event
//= require ./autotest/gui_controller

if document.addEventListener
  addEventListener "message", (e)->
    data = e.data
    Autotest.Messages.Iframe.perform(data.messageType, data)

Autotest.Messages.Iframe.post({messageType: "iframeLoadComplete"})
