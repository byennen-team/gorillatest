window.utils = {
  # extractSelector: (workspace, sel) ->
  #   $page =
  #   if _(sel).isFunction()
  #       result = sel($page)
  #       if result instanceof jQuery
  #           return result
  #       else
  #           throw new Error('Expected function to return jQuery object:', sel)
  #   else
  #       return $page.find(sel).filter(":visible")

  eventFire: ($el, eventName, opts={}) ->
      eventType = utils.translateEventNameToType eventName
      el = $el.get(0)

      if el.dispatchEvent?
          evObj = document.createEvent(eventType)
          evObj.initEvent eventName, true, true
          for key, val of opts
              evObj[key] = val
          el.dispatchEvent evObj
      else
          el.fireEvent "on" + eventName

  translateEventNameToType: (eventName) ->
      if _(["mouseenter", "mouseover", "mousedown", "mouseup", "click"]).contains(eventName)
          return "MouseEvents"
      return "Events"

  # return {
  #     extractSelector: extractSelector
  #     eventFire: eventFire
  # }
}