$(document).ready ->
  $("#login-form").validate
    rules:
      email:
        required: true

      password:
        required: true
        email: true

    highlight: (element) ->
      $(element).closest(".control-group").removeClass("success").addClass "error"
      return

    success: (element) ->
      element.text("Ok").addClass("valid").closest(".control-group").removeClass("error").addClass "success"
      return
