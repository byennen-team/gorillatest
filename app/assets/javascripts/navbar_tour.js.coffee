$ ->
  $("#dashboard-tour").joyride
    tipLocation: "bottom"
    # pauseAfter: [0, 2]
    startOffset: 0
    # postStepCallback: (i, tip)->
    #   if $(this).joyride("paused")
    #     $("h1").unbind("click")
    #     $("h1").click ->
    #       console.log("h1 click")
    #       $(window).joyride('resume')

  $("#dashboard-tour").joyride()


  $("#test-run-tour").joyride()

  $("#sample-project-tour").joyride()
