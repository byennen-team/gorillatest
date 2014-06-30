$ ->
  $('a[rel~="tooltip"]').tooltip()

  if $("ul.project").length == 0
    $("#add-project").modal
      backdrop: 'static'
      keyboard: false

  # if $(".verify-script").length == 1
  #   $(".view-embed-code").trigger("click")

  #if($(".script-status").length > 0 && $(".script-status").attr("script-verified") == "false")
  #  $(".embed-modal").modal
  #    backdrop: 'static'
  #    keyboard: false
  #    show: true

  $(".lets-verify-link").click (e)->
    e.preventDefault()
    $(".embed-modal").modal("show")
    $(".verify-script-modal-button").trigger("click")

  $(".verify-script-modal-button").on "click", (e)->
    e.preventDefault()
    button = $(this)
    gif = button.prev(".loading-gif")
    button.hide()
    gif.show()
    $.ajax $(this).attr("href"),
      type: 'post'
      cache: false
      complete: (jqXHR, textStatus) ->
        if jqXHR.status == 200
          $(gif).hide()
          $(button).show()
          $(button).text("Verified!")
          setTimeout (->
            window.location.href = $(button).attr('project_link')
            return
          ), 500
        else
          error = $.parseJSON(jqXHR.responseText).message
          $(gif).hide()
          $(button).show()
          $(button).text(error + " Click to try again.")
        return
