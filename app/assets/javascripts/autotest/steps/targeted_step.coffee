hubspot.define "hubspot.integrate.steps.targeted_step", [
    "hubspot.integrate.utils"
], (utils) ->
    class TargetedStep extends Backbone.Model
        constructor: (@sel) ->
            super()

        getTarget: (workspace) ->
            @$target = utils.extractSelector(workspace, @sel)
            @set 'targetElement', @$target
            return @$target


