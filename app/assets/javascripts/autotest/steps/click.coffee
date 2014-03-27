class ClickStep

  mood: "click"

  announcement: ->
    if _(@sel).isFunction()
        return "Clicking on: <pre class='function'>#{@sel}</pre>"
    else
        return "Clicking on: <pre>$page.find(\"#{@sel}\")</pre>"

  perform: (workspace) ->
    if @$target.length isnt 1
        return false

    $page = workspace.getPage()
    unless $page.find(@$target).length is 1
        return false  # target is no longer in the DOM

    utils.eventFire(workspace, @$target, "mouseenter")
    utils.eventFire(workspace, @$target, "mouseover")
    utils.eventFire(workspace, @$target, "click")
    utils.eventFire(workspace, @$target, "mousedown")
    utils.eventFire(workspace, @$target, "mouseup")

    return @$target