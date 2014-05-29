$.throttle_delay = 350
$.menu_speed = 235
$.navbar_height = 49
$.root_ = $("body")
$.left_panel = $("#left-panel")

nav_page_height = ->
  setHeight = $("#main").height()

  #menuHeight = $.left_panel.height();
  windowHeight = $(window).height() - $.navbar_height

  #set height
  if setHeight > windowHeight # if content height exceedes actual window height and menuHeight
    $.left_panel.css "min-height", setHeight + "px"
    $.root_.css "min-height", setHeight + $.navbar_height + "px"
  else
    $.left_panel.css "min-height", windowHeight + "px"
    $.root_.css "min-height", windowHeight + "px"
  return

$.fn.extend jarvismenu: (options) ->
  defaults =
    accordion: "true"
    speed: 200
    closedSign: "[+]"
    openedSign: "[-]"

  opts = $.extend(defaults, options)
  $this = $(this)
  $this.find("li").each ->
    unless $(this).find("ul").size() is 0
      $(this).find("a:first").append "<b class='collapse-sign'>" + opts.closedSign + "</b>"
      if $(this).find("a:first").attr("href") is "#"
        $(this).find("a:first").click ->
          false

    return

  $this.find("li.active").each ->
    $(this).parents("ul").slideDown opts.speed
    $(this).parents("ul").parent("li").find("b:first").html opts.openedSign
    $(this).parents("ul").parent("li").addClass "open"
    return

  $this.find("li a").click ->
    unless $(this).parent().find("ul").size() is 0
      if opts.accordion
        unless $(this).parent().find("ul").is(":visible")
          parents = $(this).parent().parents("ul")
          visible = $this.find("ul:visible")
          visible.each (visibleIndex) ->
            close = true
            parents.each (parentIndex) ->
              if parents[parentIndex] is visible[visibleIndex]
                close = false
                false

            if close
              unless $(this).parent().find("ul") is visible[visibleIndex]
                $(visible[visibleIndex]).slideUp opts.speed, ->
                  $(this).parent("li").find("b:first").html opts.closedSign
                  $(this).parent("li").removeClass "open"
                  return

            return

      if $(this).parent().find("ul:first").is(":visible") and not $(this).parent().find("ul:first").hasClass("active")
        $(this).parent().find("ul:first").slideUp opts.speed, ->
          $(this).parent("li").removeClass "open"
          $(this).parent("li").find("b:first").delay(opts.speed).html opts.closedSign
          return

      else
        $(this).parent().find("ul:first").slideDown opts.speed, ->
          $(this).parent("li").addClass "open"
          $(this).parent("li").find("b:first").delay(opts.speed).html opts.openedSign
          return

    return

  return


$(document).ready ->
  $("[rel=tooltip]").tooltip() if $("[rel=tooltip]").length
  nav_page_height()
  unless null
    $("nav ul").jarvismenu
      accordion: true
      speed: $.menu_speed
      closedSign: "<em class=\"fa fa-rotate-180 fa-expand-o\"></em>"
      openedSign: "<em class=\"fa fa-collapse-o\"></em>"

  else
    alert "Error - menu anchor does not exist"
  $(".minifyme").click (e) ->
    $("body").toggleClass "minified"
    e.preventDefault()
    return

  $("#hide-menu >:first-child > a").click (e) ->
    $("body").toggleClass "hidden-menu"
    e.preventDefault()
    return
