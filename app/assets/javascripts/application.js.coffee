//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore
//= require userFlow
//= require plugins/jquery.validate.min
//= require plugins/jquery.easing.min
//= require layout
//= require project

$(document).ready( ->
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
)
