hubspot.define "hubspot.integrate.steps.custom_function", [
    "hubspot.integrate.utils"
], (utils) ->
    class CustomFunctionStep extends Backbone.Model
        constructor: (@inFunc) ->
            super()

        announcement: ->
            "Performing custom step: <pre>#{@inFunc}</pre>"

        perform: (workspace) ->
            appWindow = workspace.get("$iframe").get(0).contentWindow
            return @inFunc(appWindow)

