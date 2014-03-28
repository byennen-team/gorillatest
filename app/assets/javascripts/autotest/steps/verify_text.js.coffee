class Autotest.Steps.VerifyTextStep extends Autotest.Steps.TargetedStep

  constructor: (@step) ->
    super(@step)

  mood: "look"

  perform: ->
    matched = $("body:contains('#{@text}')")
    if matched.length > 0
      # @findAndReplace(@text)
      return @$target
    else
      return false

  # findAndReplace: (searchText, searchNode) ->

  #   # Throw error here if you want...
  #   # return  if not searchText or typeof replacement is "undefined"
  #   regex = (if typeof searchText is "string" then new RegExp(searchText, "g") else searchText)
  #   childNodes = (searchNode || document.body).childNodes
  #   cnLength = childNodes.length
  #   excludes = "html,head,style,title,link,meta,script,object,iframe"
  #   while cnLength--
  #     currentNode = childNodes[cnLength]
  #     # continue  if currentNode.nodeType isnt 3 or not regex.test(currentNode.data)
  #     if currentNode.nodeType == 1 and (excludes + ",").indexOf(currentNode.nodeName.toLowerCase() + ",") == -1
  #       console.log("recursing")
  #       @findAndReplace(searchText, currentNode)
  #     continue  if currentNode.nodeType isnt 3 or not regex.test(currentNode.data)
  #     parent = currentNode.parentNode
  #     console.log(currentNode.data)
  #     #replacmentText = "<span style='background: red;' class='autotest-highlight'>#{@text}</span>"
  #     replacementText = "verified"
  #     $(currentNode).text().replace("Select", replacementText)
  #     # frag = (->
  #     #   html = currentNode.data.replace(regex, "<span class='highlight'>#{@text}</span>")
  #     #   wrap = document.createElement("div")
  #     #   frag = document.createDocumentFragment()
  #     #   wrap.innerHTML = html
  #     #   frag.appendChild wrap.firstChild  while wrap.firstChild
  #     #   frag
  #     # )()
  #     # parent.insertBefore frag, currentNode
  #     # parent.removeChild currentNode
  #   return

Autotest.Developer.Steps.add("verifyText", (step) ->
  verifyTextStep = new Autotest.Steps.VerifyTextStep(step)
  return verifyTextStep.perform()
)