$(document).ready ->
  $("#registration-form").validate
    rules:
      first_name:
        minlength: 2
        required: true

      last_name:
        required: true
        email: true

      email:
        minlength: 2
        required: true

      password:
        minlength: 2
        required: true

    highlight: (element) ->
      $(element).closest(".control-group").removeClass("success").addClass "error"
      return

    success: (element) ->
      element.text("Ok").addClass("valid").closest(".control-group").removeClass("error").addClass "success"
      return
