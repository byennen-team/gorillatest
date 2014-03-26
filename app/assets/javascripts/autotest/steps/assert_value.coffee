hubspot.define "hubspot.integrate.steps.assert_value", [
    "hubspot.integrate.utils"
    "hubspot.integrate.steps.targeted_step"
], (utils, TargetedStep) ->
    class AssertValueStep extends TargetedStep
        constructor: (@sel, @expected) ->
            super

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
