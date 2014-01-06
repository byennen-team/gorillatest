$ ->
  $.getJSON "http://anyorigin.com/dev/get?url=https%3A//www.factor75.com&callback=?", (data) ->
    $("#site_recorder").html data.contents  
