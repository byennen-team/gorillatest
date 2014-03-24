//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require userFlow
//= require plugins/jquery.validate.min
//= require plugins/jquery.easing.min
//= require layout

$(document).ready(function(){
  var target = window.location.hash
  if(target != ""){
    $("a[href='" + target + "']").tab("show")
  }
})
//= require underscore
//= require backbone
//= require autotest
//= require_tree ../templates
//= require_tree ./models
//= require_tree ./collections
//= require_tree ./views
//= require_tree ./routers
