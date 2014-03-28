//= require bPopup.min

//= require underscore
//= require ./plugins/jquery.xpath
//= require ./plugins/jquery.purl
//= require backbone
//= require backbone_rails_sync
//= require autotest/autotest
//= require_tree ./autotest/templates
//= require_tree ./autotest/models
//= require_tree ./autotest/collections
//= require_tree ./autotest/views
//= require_tree ./autotest/routers
//= require autotest/gui_controller
//= require ./autotest/recorder
//= require ./autotest/messages/parent
//= require ./autotest/locator_builder
//= require ./autotest/locator
//= require ./autotest/event
//= require_tree ./autotest/developer
//= require ./autotest/utils
//= require ./autotest/steps/targeted_step
//= require ./autotest/steps/type
//= require ./autotest/steps/verify_element
//= require ./autotest/steps/verify_text
//= require ./autotest/steps/click
//= require_self

# Need to figure out how to namespace these so they don't pollute global windows vars - jkr
$(document).ready () ->

  window.addEventListener "message", (e)->
    Autotest.Messages.Parent.perform(e.data.messageType, e.data.featureId)