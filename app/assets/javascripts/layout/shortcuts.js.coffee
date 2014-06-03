shortcut_buttons_hide = ->
  $("#shortcut").animate
    height: "hide", 300, "easeOutCirc"
    $("body").removeClass "shortcut-on"
  return

shortcut_buttons_show = ->
  $("#shortcut").animate
    height: "show", 200, "easeOutCirc"
    $("body").addClass "shortcut-on"
  return

$(document).ready ->
  $("#show-shortcut").click (e) ->
    if $("#shortcut").is(":visible")
      shortcut_buttons_hide()
    else
      shortcut_buttons_show()

  $("#show-shortcut").find("a").click (e) ->
    e.preventDefault()
    window.location = $(this).attr("href")
    setTimeout shortcut_buttons_hide, 300
    return

  $(document).mouseup (e) ->
    shortcut_buttons_hide()  if not $("#shortcut").is(e.target) and $("#shortcut").has(e.target).length is 0
    return
