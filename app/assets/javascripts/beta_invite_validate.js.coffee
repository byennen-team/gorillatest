# $(document).ready ->
#   req = "return $.trim(VAL) != '';"
#   email = "return $.trim(VAL).match(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i)"

#   bind_address_validations = (e)->

#     modal = $(e.target)

#     fn = modal.find("#beta_invitation_first_name").validate()
#     debugger
#     fn.settings.rules = {expression: req, message: "First name is required."}

#     # modal.find("#beta_invitation_last_name").validate
#     #   expression: req
#     #   message: "Last name is required."

#     # modal.find("#beta_invitation_email").validate
#     #   expression: req
#     #   message: "Email is required."

#     # modal.find("#beta_invitation_email").validate
#     #   expression: email
#     #   message: "- invalid email"

#   unbind_address_validations = (e)->
#     $(e.target).find('input').off()

#   $(".modal")
#     .on('show.bs.modal', bind_address_validations)
#     .on('hide.bs.modal', unbind_address_validations)

$ ->
  $(".modal").find("input").on "keyup", ->
    inputs = [$("#beta_invitation_first_name"),
              $("#beta_invitation_last_name"),
              $("#beta_invitation_email")]

    formComplete = _.every inputs, (input)->
      return input.val().length > 0

    if formComplete
      $(".beta-invite-submit-button").attr("disabled", false)
    else
      $(".beta-invite-submit-button").attr("disabled", true)
