//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require userFlow

$(document).ready(function(){
  var target = window.location.hash
  if(target != ""){
    $("a[href='" + target + "']").tab("show")
  }
})
