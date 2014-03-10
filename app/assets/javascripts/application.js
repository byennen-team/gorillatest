//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require userFlow
//= require plugins/jquery.validate.min
//= require plugins/jquery.easing.min

  $(document).ready(function(){
  var target = window.location.hash
  if(target != ""){
    $("a[href='" + target + "']").tab("show")
  }
})
