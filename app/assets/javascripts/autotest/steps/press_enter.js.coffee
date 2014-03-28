# class PressEnterStep #extends TargetedStep

#   constructor: (@step) ->
#     @$target = @step.element()
#     @text = @step.get("text")

#   mood: "locate"

#   announcement: "Pressing enter."

#   perform: (workspace) ->
#     @$target = utils.extractSelector(workspace, @sel)
#     if @$target.length isnt 1
#         return false

#     opts = {which: 13}
#     utils.eventFire(workspace, @$target, "keydown", opts)
#     utils.eventFire(workspace, @$target, "keyup", opts)
#     utils.eventFire(workspace, @$target, "keypress", opts)
#     return @$target
