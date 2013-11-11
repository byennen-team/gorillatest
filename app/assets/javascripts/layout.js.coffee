$(document).ready ->
  #added active class to links
  $("a[href=\"" + @location.pathname + "\"]").parent().addClass "active"
