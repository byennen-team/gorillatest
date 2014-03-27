class AssertValueStep #extends TargetedStep
  constructor: (@step) ->
    @$target = @step.element()
    @text = @step.get("text")

  mood: "look"

  announcement: ->
    if _(@sel).isFunction()
      return "Expecting \"#{@expected}\" to match value of: <pre class='function'>#{@sel}</pre>"
    else
      return "Expecting \"#{@expected}\" to match value of: <pre>#{@sel}</pre>"

  perform: (workspace) ->
    if @$target.length isnt 1
      return

      # Only check for expected text content if a string was passed
    if @expected?
      matched = @$target.val().trim().toLowerCase().indexOf(@expected.toLowerCase()) > -1

      if matched
        return @$target
      else
        return false

    else
      return true