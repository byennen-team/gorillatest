hubspot.define("hubspot.integrate.steps.focus_iframe", [
    "hubspot.integrate.utils"
], (utils) ->
    class FocusIframeStep extends Backbone.Model
        constructor: (@sel) ->
            super()

        mood: "locate"

        announcement: ->
            if _(@sel).isFunction()
                return "Looking for iframe: <pre class='function'>#{@sel}</pre>"
            else
                return "Looking for iframe: <pre>$page.find(\"#{@sel}\")</pre>"

        perform: (workspace) ->
            if not @sel?
                workspace.focusIframe()
                return true

            $item = utils.extractSelector(workspace, @sel)
            workspace.focusIframe($item)

            return $item
)
