$ ->
  # try
  #   Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  # catch exception
  #   alert(exception)
  credit_card.setupForm()

credit_card =
  setupForm: ->
    $('#new_credit_card').submit (e) ->
      e.preventDefault()
      $("#new_credit_card .spinner").toggle()
      $('#new_credit_card input[type=submit]').val("Saving...")
      $('#new_credit_card input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        credit_card.processCard()

  processCard: ->
    card =
      name: $("#name").val()
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, credit_card.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if response.error
      $('#stripe_error').empty().text(response.error.message)
      $("#new_credit_card .spinner").toggle()
      $('#new_credit_card input[type=submit]').val("Save Credit Card")
      $('#new_credit_card input[type=submit]').attr('disabled', false)
    else
      #$('#stripe_token').val(response.id)
      #debugger
      # $('#new_credit_card').get(0).submit()
      stripe_token = response.id
      url = $("form#new_credit_card").attr("action");
      console.log("Calling AJAX")
      $.ajax(
        url: url
        type: 'POST'
        data: {stripe_token: stripe_token}
        success: ->
          console.log("Calling successes")
          console.log("We have liftoff")
          window.location.href = "/users/edit#change-plan"
        error: ->
          console.log("Calling error")
          alert("Your card could not be charged")
      )