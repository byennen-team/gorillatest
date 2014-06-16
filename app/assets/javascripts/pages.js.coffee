$(document).ready ->
  $(".imac, .demo-video").animate
    top:'+=20',
    opacity:'1.0',
    1000, 'easeInExpo'

  $("#login-box").animate
    top:'+=20',
    opacity:'1.0',
    500, 'easeInExpo'

  $('#auth_options').delay(500).animate
    opacity:'1.0',
    500, 'easeInSine'

