#
# * VARIABLES
# * Description: All Global Vars
#

# Impacts the responce rate of some of the responsive elements (lower value affects CPU but improves speed)
$.throttle_delay = 350

# The rate at which the menu expands revealing child elements on click
$.menu_speed = 235

# Note: You will also need to change this variable in the "variable.less" file.
$.navbar_height = 49

#
# * APP DOM REFERENCES
# * Description: Obj DOM reference, please try to avoid changing these
#
$.root_ = $("body")
$.left_panel = $("#left-panel")
$.shortcut_dropdown = $("#shortcut")
$.bread_crumb = $("#ribbon ol.breadcrumb")

# desktop or mobile
$.device = null

#
# * APP CONFIGURATION
# * Description: Enable / disable certain theme features here
#
$.navAsAjax = false # Your left nav in your app will no longer fire ajax calls

# Please make sure you have included "jarvis.widget.js" for this below feature to work
$.enableJarvisWidgets = true

# Warning: Enabling mobile widgets could potentially crash your webApp if you have too many
# 			widgets running at once (must have $.enableJarvisWidgets = true)
$.enableMobileWidgets = false

#
# * DETECT MOBILE DEVICES
# * Description: Detects mobile device - if any of the listed device is detected
# * a class is inserted to $.root_ and the variable $.device is decleard.
#

# so far this is covering most hand held devices
ismobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()))
unless ismobile

  # Desktop
  $.root_.addClass "desktop-detected"
  $.device = "desktop"
else

  # Mobile
  $.root_.addClass "mobile-detected"
  $.device = "mobile"

# Removes the tap delay in idevices
# dependency: js/plugin/fastclick/fastclick.js
#FastClick.attach(document.body);

$(document).ready ->

  #
  #   * Fire tooltips
  #

  #TODO: was moved from window.load due to IE not firing consist

  # INITIALIZE LEFT NAV

  # COLLAPSE LEFT NAV

  # HIDE MENU

  # SHOW & HIDE MOBILE SEARCH FIELD

  # ACTIVITY
  # ajax drop

  # console.log("Ajax call for activity")

  #console.log(mytest)

  #alert($(this).val())
  # if the target of the click isn't the container...

  # NOTIFICATION IS PRESENT
  notification_check = ->
    $this = $("#activity > .badge")
    $this.addClass "bg-color-red bounceIn animated"  if parseInt($this.text()) > 0
    return

  # RESET WIDGETS

  # LOGOUT BUTTON

  #get the link

  # ask verification

  #
  #   * LOGOUT ACTION
  #
  logout = ->
    window.location = $.loginURL
    return

  #
  #   * SHORTCUTS
  #

  # SHORT CUT (buttons that appear when clicked on user name)

  # SHORTCUT buttons goes away if mouse is clicked outside of the area
  # if the target of the click isn't the container...

  # SHORTCUT ANIMATE HIDE
  shortcut_buttons_hide = ->
    $.shortcut_dropdown.animate
      height: "hide"
    , 300, "easeOutCirc"
    $.root_.removeClass "shortcut-on"
    return

  # SHORTCUT ANIMATE SHOW
  shortcut_buttons_show = ->
    $.shortcut_dropdown.animate
      height: "show"
    , 200, "easeOutCirc"
    $.root_.addClass "shortcut-on"
    return
  $("[rel=tooltip]").tooltip()  if $("[rel=tooltip]").length
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

  $("#show-shortcut").click (e) ->
    alert "Lance"
    if $.shortcut_dropdown.is(":visible")
      shortcut_buttons_hide()
    else
      shortcut_buttons_show()
    e.preventDefault()
    return

  $("#search-mobile").click ->
    $.root_.addClass "search-mobile"
    return

  $("#cancel-search-js").click ->
    $.root_.removeClass "search-mobile"
    return

  $("#activity").click (e) ->
    $this = $(this)
    if $this.find(".badge").hasClass("bg-color-red")
      $this.find(".badge").removeClassPrefix "bg-color-"
      $this.find(".badge").text "0"
    unless $this.next(".ajax-dropdown").is(":visible")
      $this.next(".ajax-dropdown").fadeIn 150
      $this.addClass "active"
    else
      $this.next(".ajax-dropdown").fadeOut 150
      $this.removeClass "active"
    mytest = $this.next(".ajax-dropdown").find(".btn-group > .active > input").attr("id")
    e.preventDefault()
    return

  $("input[name=\"activity\"]").change ->
    $this = $(this)
    url = $this.attr("id")
    container = $(".ajax-notifications")
    loadURL url, container
    return

  $(document).mouseup (e) ->
    if not $(".ajax-dropdown").is(e.target) and $(".ajax-dropdown").has(e.target).length is 0
      $(".ajax-dropdown").fadeOut 150
      $(".ajax-dropdown").prev().removeClass "active"
    return

  $("button[data-loading-text]").on "click", ->
    btn = $(this)
    btn.button "loading"
    setTimeout (->
      btn.button "reset"
      return
    ), 3000
    return

  notification_check()
  $("#refresh").click (e) ->
    $.SmartMessageBox
      title: "<i class='fa fa-refresh' style='color:green'></i> Clear Local Storage"
      content: "Would you like to RESET all your saved widgets and clear LocalStorage?"
      buttons: "[No][Yes]"
    , (ButtonPressed) ->
      if ButtonPressed is "Yes" and localStorage
        localStorage.clear()
        location.reload()
      return

    e.preventDefault()
    return

  $("#logout a").click (e) ->
    $this = $(this)
    $.loginURL = $this.attr("href")
    $.logoutMSG = $this.data("logout-msg")
    $.SmartMessageBox
      title: "<i class='fa fa-sign-out txt-color-orangeDark'></i> Logout <span class='txt-color-orangeDark'><strong>" + $("#show-shortcut").text() + "</strong></span> ?"
      content: $.logoutMSG or "You can improve your security further after logging out by closing this opened browser"
      buttons: "[No][Yes]"
    , (ButtonPressed) ->
      if ButtonPressed is "Yes"
        $.root_.addClass "animated fadeOutUp"
        setTimeout logout, 1000
      return

    e.preventDefault()
    return

  $.shortcut_dropdown.find("a").click (e) ->
    e.preventDefault()
    window.location = $(this).attr("href")
    setTimeout shortcut_buttons_hide, 300
    return

  $(document).mouseup (e) ->
    shortcut_buttons_hide()  if not $.shortcut_dropdown.is(e.target) and $.shortcut_dropdown.has(e.target).length is 0
    return

  return

#
# * RESIZER WITH THROTTLE
# * Source: http://benalman.com/code/projects/jquery-resize/examples/resize/
#

#
# * NAV OR #LEFT-BAR RESIZE DETECT
# * Description: changes the page min-width of #CONTENT and NAV when navigation is resized.
# * This is to counter bugs for min page width on many desktop and mobile devices.
# * Note: This script uses JSthrottle technique so don't worry about memory/CPU usage
#

# Fix page and nav height
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
check_if_mobile_width = ->
  if $(window).width() < 979
    $.root_.addClass "mobile-view-activated"
  else $.root_.removeClass "mobile-view-activated"  if $.root_.hasClass("mobile-view-activated")
  return

# ~ END: NAV OR #LEFT-BAR RESIZE DETECT

#
# * DETECT IE VERSION
# * Description: A short snippet for detecting versions of IE in JavaScript
# * without resorting to user-agent sniffing
# * RETURNS:
# * If you're not in IE (or IE version is less than 5) then:
# * //ie === undefined
# *
# * If you're in IE (>=5) then you can determine which version:
# * // ie === 7; // IE7
# *
# * Thus, to detect IE:
# * // if (ie) {}
# *
# * And to detect the version:
# * ie === 6 // IE6
# * ie > 7 // IE8, IE9 ...
# * ie < 9 // Anything less than IE9
#

# TODO: delete this function later on - no longer needed (?)
# do we need this?

# ~ END: DETECT IE VERSION

#
# * CUSTOM MENU PLUGIN
#

#pass the options variable to the function

# Extend our default options with those provided.

#Assign current element to variable, in this case is UL element

#add a mark [+] to a multilevel menu

#add the multilevel sign next to the link

#avoid jumping to the top of the page when the href is an #

#open active level

#Do nothing when the list is open
# end if

#$(this).effect("highlight", {color : '#616161'}, 500); - disabled due to CPU clocking on phones
# end else
# end if
# end function

# ~ END: CUSTOM MENU PLUGIN

#
# * ELEMENT EXIST OR NOT
# * Description: returns true or false
# * Usage: $('#myDiv').doesExist();
#

# ~ END: ELEMENT EXIST OR NOT

#
# * FULL SCREEN FUNCTION
#

# Find the right method, call on correct element
launchFullscreen = (element) ->
  unless $.root_.hasClass("full-screen")
    $.root_.addClass "full-screen"
    if element.requestFullscreen
      element.requestFullscreen()
    else if element.mozRequestFullScreen
      element.mozRequestFullScreen()
    else if element.webkitRequestFullscreen
      element.webkitRequestFullscreen()
    else element.msRequestFullscreen()  if element.msRequestFullscreen
  else
    $.root_.removeClass "full-screen"
    if document.exitFullscreen
      document.exitFullscreen()
    else if document.mozCancelFullScreen
      document.mozCancelFullScreen()
    else document.webkitExitFullscreen()  if document.webkitExitFullscreen
  return

#
# * ~ END: FULL SCREEN FUNCTION
#

#
# * INITIALIZE FORMS
# * Description: Select2, Masking, Datepicker, Autocomplete
#
runAllForms = ->

  #
  #   * BOOTSTRAP SLIDER PLUGIN
  #   * Usage:
  #   * Dependency: js/plugin/bootstrap-slider
  #
  $(".slider").slider()  if $.fn.slider

  #
  #   * SELECT2 PLUGIN
  #   * Usage:
  #   * Dependency: js/plugin/select2/
  #
  if $.fn.select2
    $(".select2").each ->
      $this = $(this)
      width = $this.attr("data-select-width") or "100%"

      #, _showSearchInput = $this.attr('data-select-search') === 'true';
      $this.select2

      #showSearchInput : _showSearchInput,
        allowClear: true
        width: width

      return


  #
  #   * MASKING
  #   * Dependency: js/plugin/masked-input/
  #
  if $.fn.mask
    $("[data-mask]").each ->
      $this = $(this)
      mask = $this.attr("data-mask") or "error..."
      mask_placeholder = $this.attr("data-mask-placeholder") or "X"
      $this.mask mask,
        placeholder: mask_placeholder

      return


  #
  #   * Autocomplete
  #   * Dependency: js/jqui
  #
  if $.fn.autocomplete
    $("[data-autocomplete]").each ->
      $this = $(this)
      availableTags = $this.data("autocomplete") or [
        "The"
        "Quick"
        "Brown"
        "Fox"
        "Jumps"
        "Over"
        "Three"
        "Lazy"
        "Dogs"
      ]
      $this.autocomplete source: availableTags
      return


  #
  #   * JQUERY UI DATE
  #   * Dependency: js/libs/jquery-ui-1.10.3.min.js
  #   * Usage:
  #
  if $.fn.datepicker
    $(".datepicker").each ->
      $this = $(this)
      dataDateFormat = $this.attr("data-dateformat") or "dd.mm.yy"
      $this.datepicker
        dateFormat: dataDateFormat
        prevText: "<i class=\"fa fa-chevron-left\"></i>"
        nextText: "<i class=\"fa fa-chevron-right\"></i>"

      return


  #
  #   * AJAX BUTTON LOADING TEXT
  #   * Usage: <button type="button" data-loading-text="Loading..." class="btn btn-xs btn-default ajax-refresh"> .. </button>
  #
  $("button[data-loading-text]").on "click", ->
    btn = $(this)
    btn.button "loading"
    setTimeout (->
      btn.button "reset"
      return
    ), 3000
    return

  return

# ~ END: INITIALIZE FORMS

#
# * INITIALIZE CHARTS
# * Description: Sparklines, PieCharts
#
runAllCharts = ->

  #
  #   * SPARKLINES
  #   * DEPENDENCY: js/plugins/sparkline/jquery.sparkline.min.js
  #   * See usage example below...
  #

  # Usage:
  #   * 		<div class="sparkline-line txt-color-blue" data-fill-color="transparent" data-sparkline-height="26px">
  #   *			5,6,7,9,9,5,9,6,5,6,6,7,7,6,7,8,9,7
  #   *		</div>
  #
  if $.fn.sparkline
    $(".sparkline").each ->
      $this = $(this)
      sparklineType = $this.data("sparkline-type") or "bar"

      # BAR CHART
      if sparklineType is "bar"
        barColor = $this.data("sparkline-bar-color") or $this.css("color") or "#0000f0"
        sparklineHeight = $this.data("sparkline-height") or "26px"
        sparklineBarWidth = $this.data("sparkline-barwidth") or 5
        sparklineBarSpacing = $this.data("sparkline-barspacing") or 2
        sparklineNegBarColor = $this.data("sparkline-negbar-color") or "#A90329"
        sparklineStackedColor = $this.data("sparkline-barstacked-color") or [
          "#A90329"
          "#0099c6"
          "#98AA56"
          "#da532c"
          "#4490B1"
          "#6E9461"
          "#990099"
          "#B4CAD3"
        ]
        $this.sparkline "html",
          type: "bar"
          barColor: barColor
          type: sparklineType
          height: sparklineHeight
          barWidth: sparklineBarWidth
          barSpacing: sparklineBarSpacing
          stackedBarColor: sparklineStackedColor
          negBarColor: sparklineNegBarColor
          zeroAxis: "false"


      #LINE CHART
      if sparklineType is "line"
        sparklineHeight = $this.data("sparkline-height") or "20px"
        sparklineWidth = $this.data("sparkline-width") or "90px"
        thisLineColor = $this.data("sparkline-line-color") or $this.css("color") or "#0000f0"
        thisLineWidth = $this.data("sparkline-line-width") or 1
        thisFill = $this.data("fill-color") or "#c0d0f0"
        thisSpotColor = $this.data("sparkline-spot-color") or "#f08000"
        thisMinSpotColor = $this.data("sparkline-minspot-color") or "#ed1c24"
        thisMaxSpotColor = $this.data("sparkline-maxspot-color") or "#f08000"
        thishighlightSpotColor = $this.data("sparkline-highlightspot-color") or "#50f050"
        thisHighlightLineColor = $this.data("sparkline-highlightline-color") or "f02020"
        thisSpotRadius = $this.data("sparkline-spotradius") or 1.5
        thisChartMinYRange = $this.data("sparkline-min-y") or "undefined"
        thisChartMaxYRange = $this.data("sparkline-max-y") or "undefined"
        thisChartMinXRange = $this.data("sparkline-min-x") or "undefined"
        thisChartMaxXRange = $this.data("sparkline-max-x") or "undefined"
        thisMinNormValue = $this.data("min-val") or "undefined"
        thisMaxNormValue = $this.data("max-val") or "undefined"
        thisNormColor = $this.data("norm-color") or "#c0c0c0"
        thisDrawNormalOnTop = $this.data("draw-normal") or false

        $this.sparkline "html",
          type: "line"
          width: sparklineWidth
          height: sparklineHeight
          lineWidth: thisLineWidth
          lineColor: thisLineColor
          fillColor: thisFill
          spotColor: thisSpotColor
          minSpotColor: thisMinSpotColor
          maxSpotColor: thisMaxSpotColor
          highlightSpotColor: thishighlightSpotColor
          highlightLineColor: thisHighlightLineColor
          spotRadius: thisSpotRadius
          chartRangeMin: thisChartMinYRange
          chartRangeMax: thisChartMaxYRange
          chartRangeMinX: thisChartMinXRange
          chartRangeMaxX: thisChartMaxXRange
          normalRangeMin: thisMinNormValue
          normalRangeMax: thisMaxNormValue
          normalRangeColor: thisNormColor
          drawNormalOnTop: thisDrawNormalOnTop


      #PIE CHART
      if sparklineType is "pie"
        pieColors = $this.data("sparkline-piecolor") or [
          "#B4CAD3"
          "#4490B1"
          "#98AA56"
          "#da532c"
          "#6E9461"
          "#0099c6"
          "#990099"
          "#717D8A"
        ]
        pieWidthHeight = $this.data("sparkline-piesize") or 90
        pieBorderColor = $this.data("border-color") or "#45494C"
        pieOffset = $this.data("sparkline-offset") or 0
        $this.sparkline "html",
          type: "pie"
          width: pieWidthHeight
          height: pieWidthHeight
          tooltipFormat: "<span style=\"color: {{color}}\">&#9679;</span> ({{percent.1}}%)"
          sliceColors: pieColors
          offset: 0
          borderWidth: 1
          offset: pieOffset
          borderColor: pieBorderColor


      #BOX PLOT
      if sparklineType is "box"
        thisBoxWidth = $this.data("sparkline-width") or "auto"
        thisBoxHeight = $this.data("sparkline-height") or "auto"
        thisBoxRaw = $this.data("sparkline-boxraw") or false
        thisBoxTarget = $this.data("sparkline-targetval") or "undefined"
        thisBoxMin = $this.data("sparkline-min") or "undefined"
        thisBoxMax = $this.data("sparkline-max") or "undefined"
        thisShowOutlier = $this.data("sparkline-showoutlier") or true
        thisIQR = $this.data("sparkline-outlier-iqr") or 1.5
        thisBoxSpotRadius = $this.data("sparkline-spotradius") or 1.5
        thisBoxLineColor = $this.css("color") or "#000000"
        thisBoxFillColor = $this.data("fill-color") or "#c0d0f0"
        thisBoxWhisColor = $this.data("sparkline-whis-color") or "#000000"
        thisBoxOutlineColor = $this.data("sparkline-outline-color") or "#303030"
        thisBoxOutlineFill = $this.data("sparkline-outlinefill-color") or "#f0f0f0"
        thisBoxMedianColor = $this.data("sparkline-outlinemedian-color") or "#f00000"
        thisBoxTargetColor = $this.data("sparkline-outlinetarget-color") or "#40a020"
        $this.sparkline "html",
          type: "box"
          width: thisBoxWidth
          height: thisBoxHeight
          raw: thisBoxRaw
          target: thisBoxTarget
          minValue: thisBoxMin
          maxValue: thisBoxMax
          showOutliers: thisShowOutlier
          outlierIQR: thisIQR
          spotRadius: thisBoxSpotRadius
          boxLineColor: thisBoxLineColor
          boxFillColor: thisBoxFillColor
          whiskerColor: thisBoxWhisColor
          outlierLineColor: thisBoxOutlineColor
          outlierFillColor: thisBoxOutlineFill
          medianColor: thisBoxMedianColor
          targetColor: thisBoxTargetColor


      #BULLET
      if sparklineType is "bullet"
        thisBulletHeight = $this.data("sparkline-height") or "auto"
        thisBulletWidth = $this.data("sparkline-width") or 2
        thisBulletColor = $this.data("sparkline-bullet-color") or "#ed1c24"
        thisBulletPerformanceColor = $this.data("sparkline-performance-color") or "#3030f0"
        thisBulletRangeColors = $this.data("sparkline-bulletrange-color") or [
          "#d3dafe"
          "#a8b6ff"
          "#7f94ff"
        ]
        $this.sparkline "html",
          type: "bullet"
          height: thisBulletHeight
          targetWidth: thisBulletWidth
          targetColor: thisBulletColor
          performanceColor: thisBulletPerformanceColor
          rangeColors: thisBulletRangeColors


      #DISCRETE
      if sparklineType is "discrete"
        thisDiscreteHeight = $this.data("sparkline-height") or 26
        thisDiscreteWidth = $this.data("sparkline-width") or 50
        thisDiscreteLineColor = $this.css("color")
        thisDiscreteLineHeight = $this.data("sparkline-line-height") or 5
        thisDiscreteThrushold = $this.data("sparkline-threshold") or "undefined"
        thisDiscreteThrusholdColor = $this.data("sparkline-threshold-color") or "#ed1c24"
        $this.sparkline "html",
          type: "discrete"
          width: thisDiscreteWidth
          height: thisDiscreteHeight
          lineColor: thisDiscreteLineColor
          lineHeight: thisDiscreteLineHeight
          thresholdValue: thisDiscreteThrushold
          thresholdColor: thisDiscreteThrusholdColor


      #TRISTATE
      if sparklineType is "tristate"
        thisTristateHeight = $this.data("sparkline-height") or 26
        thisTristatePosBarColor = $this.data("sparkline-posbar-color") or "#60f060"
        thisTristateNegBarColor = $this.data("sparkline-negbar-color") or "#f04040"
        thisTristateZeroBarColor = $this.data("sparkline-zerobar-color") or "#909090"
        thisTristateBarWidth = $this.data("sparkline-barwidth") or 5
        thisTristateBarSpacing = $this.data("sparkline-barspacing") or 2
        thisZeroAxis = $this.data("sparkline-zeroaxis") or false
        $this.sparkline "html",
          type: "tristate"
          height: thisTristateHeight
          posBarColor: thisBarColor
          negBarColor: thisTristateNegBarColor
          zeroBarColor: thisTristateZeroBarColor
          barWidth: thisTristateBarWidth
          barSpacing: thisTristateBarSpacing
          zeroAxis: thisZeroAxis


      #COMPOSITE: BAR
      if sparklineType is "compositebar"
        sparklineHeight = $this.data("sparkline-height") or "20px"
        sparklineWidth = $this.data("sparkline-width") or "100%"
        sparklineBarWidth = $this.data("sparkline-barwidth") or 3
        thisLineWidth = $this.data("sparkline-line-width") or 1
        thisLineColor = $this.data("sparkline-color-top") or "#ed1c24"
        thisBarColor = $this.data("sparkline-color-bottom") or "#333333"
        $this.sparkline $this.data("sparkline-bar-val"),
          type: "bar"
          width: sparklineWidth
          height: sparklineHeight
          barColor: thisBarColor
          barWidth: sparklineBarWidth


        #barSpacing: 5
        $this.sparkline $this.data("sparkline-line-val"),
          width: sparklineWidth
          height: sparklineHeight
          lineColor: thisLineColor
          lineWidth: thisLineWidth
          composite: true
          fillColor: false


      #COMPOSITE: LINE
      if sparklineType is "compositeline"
        sparklineHeight = $this.data("sparkline-height") or "20px"
        sparklineWidth = $this.data("sparkline-width") or "90px"
        sparklineValue = $this.data("sparkline-bar-val")
        sparklineValueSpots1 = $this.data("sparkline-bar-val-spots-top") or null
        sparklineValueSpots2 = $this.data("sparkline-bar-val-spots-bottom") or null
        thisLineWidth1 = $this.data("sparkline-line-width-top") or 1
        thisLineWidth2 = $this.data("sparkline-line-width-bottom") or 1
        thisLineColor1 = $this.data("sparkline-color-top") or "#333333"
        thisLineColor2 = $this.data("sparkline-color-bottom") or "#ed1c24"
        thisSpotRadius1 = $this.data("sparkline-spotradius-top") or 1.5
        thisSpotRadius2 = $this.data("sparkline-spotradius-bottom") or thisSpotRadius1
        thisSpotColor = $this.data("sparkline-spot-color") or "#f08000"
        thisMinSpotColor1 = $this.data("sparkline-minspot-color-top") or "#ed1c24"
        thisMaxSpotColor1 = $this.data("sparkline-maxspot-color-top") or "#f08000"
        thisMinSpotColor2 = $this.data("sparkline-minspot-color-bottom") or thisMinSpotColor1
        thisMaxSpotColor2 = $this.data("sparkline-maxspot-color-bottom") or thisMaxSpotColor1
        thishighlightSpotColor1 = $this.data("sparkline-highlightspot-color-top") or "#50f050"
        thisHighlightLineColor1 = $this.data("sparkline-highlightline-color-top") or "#f02020"
        thishighlightSpotColor2 = $this.data("sparkline-highlightspot-color-bottom") or thishighlightSpotColor1
        thisHighlightLineColor2 = $this.data("sparkline-highlightline-color-bottom") or thisHighlightLineColor1
        thisFillColor1 = $this.data("sparkline-fillcolor-top") or "transparent"
        thisFillColor2 = $this.data("sparkline-fillcolor-bottom") or "transparent"
        $this.sparkline sparklineValue,
          type: "line"
          spotRadius: thisSpotRadius1
          spotColor: thisSpotColor
          minSpotColor: thisMinSpotColor1
          maxSpotColor: thisMaxSpotColor1
          highlightSpotColor: thishighlightSpotColor1
          highlightLineColor: thisHighlightLineColor1
          valueSpots: sparklineValueSpots1
          lineWidth: thisLineWidth1
          width: sparklineWidth
          height: sparklineHeight
          lineColor: thisLineColor1
          fillColor: thisFillColor1

        $this.sparkline $this.data("sparkline-line-val"),
          type: "line"
          spotRadius: thisSpotRadius2
          spotColor: thisSpotColor
          minSpotColor: thisMinSpotColor2
          maxSpotColor: thisMaxSpotColor2
          highlightSpotColor: thishighlightSpotColor2
          highlightLineColor: thisHighlightLineColor2
          valueSpots: sparklineValueSpots2
          lineWidth: thisLineWidth2
          width: sparklineWidth
          height: sparklineHeight
          lineColor: thisLineColor2
          composite: true
          fillColor: thisFillColor2

      return

  # end if

  #
  #   * EASY PIE CHARTS
  #   * DEPENDENCY: js/plugins/easy-pie-chart/jquery.easy-pie-chart.min.js
  #   * Usage: <div class="easy-pie-chart txt-color-orangeDark" data-pie-percent="33" data-pie-size="72" data-size="72">
  #   *			<span class="percent percent-sign">35</span>
  #   * 	  	  </div>
  #
  if $.fn.easyPieChart
    $(".easy-pie-chart").each ->
      $this = $(this)
      barColor = $this.css("color") or $this.data("pie-color")
      trackColor = $this.data("pie-track-color") or "#eeeeee"
      size = parseInt($this.data("pie-size")) or 25
      $this.easyPieChart
        barColor: barColor
        trackColor: trackColor
        scaleColor: false
        lineCap: "butt"
        lineWidth: parseInt(size / 8.5)
        animate: 1500
        rotate: -90
        size: size
        onStep: (value) ->
          @$el.find("span").text ~~value
          return

      return

  return
# end if

# ~ END: INITIALIZE CHARTS

#
# * INITIALIZE JARVIS WIDGETS
#

# Setup Desktop Widgets
setup_widgets_desktop = ->
  if $.fn.jarvisWidgets and $.enableJarvisWidgets
    $("#widget-grid").jarvisWidgets
      grid: "article"
      widgets: ".jarviswidget"
      localStorage: true
      deleteSettingsKey: "#deletesettingskey-options"
      settingsKeyLabel: "Reset settings?"
      deletePositionKey: "#deletepositionkey-options"
      positionKeyLabel: "Reset position?"
      sortable: true
      buttonsHidden: false

    # toggle button
      toggleButton: true
      toggleClass: "fa fa-minus | fa fa-plus"
      toggleSpeed: 200
      onToggle: ->


        # delete btn
      deleteButton: true
      deleteClass: "fa fa-times"
      deleteSpeed: 200
      onDelete: ->


        # edit btn
      editButton: true
      editPlaceholder: ".jarviswidget-editbox"
      editClass: "fa fa-cog | fa fa-save"
      editSpeed: 200
      onEdit: ->


        # color button
      colorButton: true

    # full screen
      fullscreenButton: true
      fullscreenClass: "fa fa-resize-full | fa fa-resize-small"
      fullscreenDiff: 3
      onFullscreen: ->


        # custom btn
      customButton: false
      customClass: "folder-10 | next-10"
      customStart: ->
        alert "Hello you, this is a custom button..."
        return

      customEnd: ->
        alert "bye, till next time..."
        return


    # order
      buttonOrder: "%refresh% %custom% %edit% %toggle% %fullscreen% %delete%"
      opacity: 1.0
      dragHandle: "> header"
      placeholderClass: "jarviswidget-placeholder"
      indicator: true
      indicatorTime: 600
      ajax: true
      timestampPlaceholder: ".jarviswidget-timestamp"
      timestampFormat: "Last update: %m%/%d%/%y% %h%:%i%:%s%"
      refreshButton: true
      refreshButtonClass: "fa fa-refresh"
      labelError: "Sorry but there was a error:"
      labelUpdated: "Last Update:"
      labelRefresh: "Refresh"
      labelDelete: "Delete widget:"
      afterLoad: ->

      rtl: false # best not to toggle this!
      onChange: ->

      onSave: ->

      ajaxnav: $.navAsAjax # declears how the localstorage should be saved

  return

# Setup Desktop Widgets
setup_widgets_mobile = ->
  setup_widgets_desktop()  if $.enableMobileWidgets and $.enableJarvisWidgets
  return

# ~ END: INITIALIZE JARVIS WIDGETS

#
# * GOOGLE MAPS
# * description: Append google maps to head dynamically
#

# ~ END: GOOGLE MAPS

#
# * LOAD SCRIPTS
# * Usage:
# * Define function = myPrettyCode ()...
# * loadScript("js/my_lovely_script.js", myPrettyCode);
#
loadScript = (scriptName, callback) ->
  unless jsArray[scriptName]
    jsArray[scriptName] = true

    # adding the script tag to the head as suggested before
    body = document.getElementsByTagName("body")[0]
    script = document.createElement("script")
    script.type = "text/javascript"
    script.src = scriptName

    # then bind the event to the callback function
    # there are several events for cross browser compatibility
    #script.onreadystatechange = callback;
    script.onload = callback

    # fire the loading
    body.appendChild script
    # changed else to else if(callback)
    #console.log("JS file already added!");
    #execute function
  else callback()  if callback
  return

# ~ END: LOAD SCRIPTS

#
# * PAGE SETUP
# * Description: fire certain scripts that run through the page
# * to check for form elements, tooltip activation, popovers, etc...
#
pageSetUp = ->
  if $.device is "desktop"

    # is desktop

    # activate tooltips
    $("[rel=tooltip]").tooltip()

    # activate popovers
    $("[rel=popover]").popover()

    # activate popovers with hover states
    $("[rel=popover-hover]").popover trigger: "hover"

    # activate inline charts
    runAllCharts()

    # setup widgets
    setup_widgets_desktop()

    #setup nav height (dynamic)
    nav_page_height()

    # run form elements
    runAllForms()
  else

    # is mobile

    # activate popovers
    $("[rel=popover]").popover()

    # activate popovers with hover states
    $("[rel=popover-hover]").popover trigger: "hover"

    # activate inline charts
    runAllCharts()

    # setup widgets
    setup_widgets_mobile()

    #setup nav height (dynamic)
    nav_page_height()

    # run form elements
    runAllForms()
  return
(($, window, undefined_) ->
  loopy = ->
    timeout_id = window[str_setTimeout](->
      elems.each ->
        elem = $(this)
        width = elem.width()
        height = elem.height()
        data = $.data(this, str_data)
        if width isnt data.w or height isnt data.h
          elem.trigger str_resize, [
            data.w = width
            data.h = height
          ]
        return

      loopy()
      return
    , jq_resize[str_delay])
    return
  elems = $([])
  jq_resize = $.resize = $.extend($.resize, {})
  timeout_id = undefined
  str_setTimeout = "setTimeout"
  str_resize = "resize"
  str_data = str_resize + "-special-event"
  str_delay = "delay"
  str_throttle = "throttleWindow"
  jq_resize[str_delay] = $.throttle_delay
  jq_resize[str_throttle] = true
  $.event.special[str_resize] =
    setup: ->
      return false  if not jq_resize[str_throttle] and this[str_setTimeout]
      elem = $(this)
      elems = elems.add(elem)
      $.data this, str_data,
        w: elem.width()
        h: elem.height()

      loopy()  if elems.length is 1
      return

    teardown: ->
      return false  if not jq_resize[str_throttle] and this[str_setTimeout]
      elem = $(this)
      elems = elems.not(elem)
      elem.removeData str_data
      clearTimeout timeout_id  unless elems.length
      return

    add: (handleObj) ->
      new_handler = (e, w, h) ->
        elem = $(this)
        data = $.data(this, str_data)
        data.w = (if w isnt `undefined` then w else elem.width())
        data.h = (if h isnt `undefined` then h else elem.height())
        old_handler.apply this, arguments_
        return
      return false  if not jq_resize[str_throttle] and this[str_setTimeout]
      old_handler = undefined
      if $.isFunction(handleObj)
        old_handler = handleObj
        new_handler
      else
        old_handler = handleObj.handler
        handleObj.handler = new_handler
      return

  return
) jQuery, this
$("#main").resize ->
  nav_page_height()
  check_if_mobile_width()
  return

$("nav").resize ->
  nav_page_height()
  return

#  ie = (->
#    undef = undefined
#    v = 3
#    div = document.createElement("div")
#    all = div.getElementsByTagName("i")
#    while div.innerHTML = "<!--[if gt IE " + (++v) + "]><i></i><![endif]-->"
#    all[0]
#
#    (if v > 4 then v else undef)
#  ())
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


jsArray = {}
if $.navAsAjax
  checkURL()  if $("nav").length
  $(document).on "click", "nav a[href!=\"#\"]", (e) ->
    e.preventDefault()
    $this = $(e.currentTarget)
    if not $this.parent().hasClass("active") and not $this.attr("target")
      if $.root_.hasClass("mobile-view-activated")
        $.root_.removeClass "hidden-menu"
        window.setTimeout (->
          if window.location.search
            window.location.href = window.location.href.replace(window.location.search, "").replace(window.location.hash, "") + "#" + $this.attr("href")
          else
            window.location.hash = $this.attr("href")
          return
        ), 150
      else
        if window.location.search
          window.location.href = window.location.href.replace(window.location.search, "").replace(window.location.hash, "") + "#" + $this.attr("href")
        else
          window.location.hash = $this.attr("href")
    return

  $(document).on "click", "nav a[target=\"_blank\"]", (e) ->
    e.preventDefault()
    $this = $(e.currentTarget)
    window.open $this.attr("href")
    return

  $(document).on "click", "nav a[target=\"_top\"]", (e) ->
    e.preventDefault()
    $this = $(e.currentTarget)
    window.location = ($this.attr("href"))
    return

  $(document).on "click", "nav a[href=\"#\"]", (e) ->
    e.preventDefault()
    return

  $(window).on "hashchange", ->
    checkURL()
    return


# Keep only 1 active popover per trigger - also check and hide active popover if user clicks on document
$("body").on "click", (e) ->
  $("[rel=\"popover\"]").each ->

    #the 'is' for buttons that trigger popups
    #the 'has' for icons within a button that triggers a popup
    $(this).popover "hide"  if not $(this).is(e.target) and $(this).has(e.target).length is 0 and $(".popover").has(e.target).length is 0
    return

  return
