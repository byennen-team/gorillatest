$ ->
  $('#purchase-ape').click ->
    $('#ape-bin').append("<p>#{$('#selected-ape').val()}</p>")

  $('#trivia-answer-button').click ->
    $('#trivia-answer').replaceWith("<span id='trivia-answer'> He is an herbivore! </span>")
    $('#trivia-answer-button').remove()