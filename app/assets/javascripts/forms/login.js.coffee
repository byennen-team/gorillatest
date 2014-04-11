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
      $(element).closest(".control-group").addClass "error"
      return
