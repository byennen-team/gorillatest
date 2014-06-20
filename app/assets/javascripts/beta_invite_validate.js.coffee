$ ->
  $("#login-box").find("input").on "keyup", ->
    inputs = [$("#beta_invitation_first_name"),
              $("#beta_invitation_last_name"),
              $("#beta_invitation_email")]

    formComplete = _.every inputs, (input)->
      return input.val().length > 0

    if formComplete
      $(".beta-invite-submit-button").attr("disabled", false)
    else
      $(".beta-invite-submit-button").attr("disabled", true)
