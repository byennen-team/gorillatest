$(document).ready ->
  $("#login-form").validate
    rules:
      email:
        required: true
        email: true

      password:
        minlength: 6
        required: true

    highlight: (element) ->
      $(element).closest(".control-group").removeClass("success").addClass "error"
      return

    success: (element) ->
      element.text("Ok").addClass("valid").closest(".control-group").removeClass("error").addClass "success"
      return
