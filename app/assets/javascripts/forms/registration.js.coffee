$(document).ready ->
  $("#registration-form").validate
    rules:
      first_name:
        minlength: 2
        required: true

      last_name:
        minlength: 2
        required: true

      email:
        email: true
        required: true

      password:
        minlength: 6
        required: true

    highlight: (element) ->
      $(element).closest(".control-group").removeClass("success").addClass "error"
      return

    success: (element) ->
      element.text("Ok").addClass("valid").closest(".control-group").removeClass("error").addClass "success"
      return
