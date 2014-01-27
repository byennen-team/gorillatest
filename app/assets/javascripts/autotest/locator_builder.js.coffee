class @AutoTestLocatorBuilder

  constructor: (@element) ->

  build: ->
    if $(@element).attr("id")
      return new AutoTestLocator "id", $(@element).attr("id")
    else if $(@element).attr("name")
      return new AutoTestLocator "name", $(@element).attr("name")
    else if $(@element).prop("tagName") == "A" && !$(@element).text().match(/^\s*$/)
      return  new AutoTestLocator "link", $(@element).text()
    else
      return new AutoTestLocator "xpath", this.buildXpath()

  buildXpath: ->
    element = @element
    paths = []
    while element && element.nodeType == 1
      index = 0
      sibling = element.previousSibling
      while sibling
        break  if sibling.nodeType == Node.DOCUMENT_TYPE_NODE
        ++index  if sibling.nodeName == element.nodeName
        sibling = sibling.previousSibling


      tagName = element.nodeName.toLowerCase()
      if index != 0
        pathIndex = "[" + (index+1) + "]"
      else
        pathIndex = ""

      paths.splice(0, 0, tagName + pathIndex)
      element = element.parentNode

    if paths.length
      return "/" + paths.join("/")
    else
      return null