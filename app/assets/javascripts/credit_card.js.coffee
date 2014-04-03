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
      name: $("#credit_card_name").val()
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
      stripe_token = response.id
      url = $("form#new_credit_card").attr("action");
      $.ajax(
        url: url
        type: 'POST',
        dataType: "json",
        data: {stripe_token: stripe_token}
        success: (data) ->
          if data.url
            window.location.href = data.url
          else
            window.location.href = "/users/edit#change-plan"
        error: ->
          alert("Your card could not be charged")
      )
