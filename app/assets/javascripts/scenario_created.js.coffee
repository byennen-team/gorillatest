$ ->

  testTemplate = _.template '<tr>
                            <td><a href="/projects/<%= project_id %>/tests/<%= scenario_id %>/test_runs"><%=scenario_name%></a></td>
                            <td class="hidden-xs hidden-sm">
                            <a class="btn btn-success" data-target="#selectBrowers_<%=scenario_id %>" data-toggle="modal" href="javascript:void(0)"><span class=" glyphicon glyphicon-play"></span> Run Test</a>
                            <div aria-hidden="true" aria-labelledby="myModalLabel" class="modal fade" id="selectBrowers_<%=scenario_id %>" role="dialog" tabindex="-1">
                            <div class="modal-dialog">
                            <form accept-charset="UTF-8" action="/projects/<%=project_id%>/tests/<%=scenario_id %>/run" class="scenario-run" method="post">
                            <div style="margin:0;padding:0;display:inline">
                            <input name="utf8" type="hidden" value="✓">
                            <input name="authenticity_token" type="hidden" value=<%= authenticity_token %>>
                            </div>
                            <div class="modal-content">
                            <div class="modal-header">
                            <button aria-hidden="true" class="close" data-dismiss="modal" type="button">×</button>
                            <h4 class="modal-title" id="myModalLabel"><%=scenario_name %></h4>
                            </div>
                            <div class="modal-body">
                            <div class="row">
                            <div class="col-sm-4">
                            <p>Select your browsers</p>
                            <h5>Windows</h5>
                            <ul>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="windows_firefox">
                            <img alt="Firefox" src="/assets/icons/firefox.png">
                            Firefox
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="windows_chrome">
                            <img alt="Chrome" src="/assets/icons/chrome.png">
                            Chrome
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="windows_ie9">
                            <img alt="Internet Explorer 9" src="/assets/icons/ie.png">
                            Internet Explorer 9
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="windows_ie10">
                            <img alt="Internet Explorer 10" src="/assets/icons/ie.png">
                            Internet Explorer 10
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="windows_ie11">
                            <img alt="Internet Explorer 11" src="/assets/icons/ie.png">
                            Internet Explorer 11
                            </li>
                            </ul>
                            </div>
                            <div class="col-sm-4">
                            <h5>OS X</h5>
                            <ul>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="mac_safari">
                            <img alt="Safari" src="/assets/icons/safari.png">
                            Safari
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="mac_firefox">
                            <img alt="Firefox" src="/assets/icons/firefox.png">
                            Firefox
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="mac_chrome">
                            <img alt="Chrome" src="/assets/icons/chrome.png">
                            Chrome
                            </li>
                            </ul>
                            </div>
                            <div class="col-sm-4">
                            <h5>Linux</h5>
                            <ul>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="linux_firefox">
                            <img alt="Firefox" src="/assets/icons/firefox.png">
                            Firefox
                            </li>
                            <li>
                            <input id="browsers_" name="browsers[]" type="checkbox" value="linux_chrome">
                            <img alt="Chrome" src="/assets/icons/chrome.png">
                            Chrome
                            </li>
                            </ul>
                            </div>
                            </div>
                            <div class="row">
                            <div class="col-sm-12">
                            <span class="hide concurrency-warning">
                            Your plan only allows
                            <span class="concurrency-limit">
                              <%= concurrency_limit %>
                            </span>
                            concurrent browsers for a test run
                            </span>
                            </div>
                            </div>
                            </div>
                            <div class="modal-footer">
                            <button class="btn btn-default" data-dismiss="modal" type="button">Close</button>
                            <input class="btn btn-info run-test" disabled="disabled" name="commit" type="submit" value="Run Tests">
                            </div>
                            </div>
                            </form>

                            </div>
                            </div>

                            </td>
                            <td class="hidden-xs hidden-sm">

                            </td>
                            </tr>'

  switchRunTestButton = (el)->
    button = $(el).closest("form.scenario-run").find("input.run-test")
    concurrencyLimit = parseInt $(".concurrency-limit").text()
    numChecked = $(el).closest("form.scenario-run").find("input:checked").length
    concurrencyWarning = $(el).closest(".modal-body").find(".concurrency-warning")

    if numChecked > concurrencyLimit
      button.attr("disabled", true)
      concurrencyWarning.removeClass("hide")
    else if $(el).closest("form.scenario-run").find("input:checked").length > 0
      button.removeAttr("disabled")
      concurrencyWarning.addClass("hide")
    else
      button.attr("disabled", true)

  # projectId = $("#pusher-project-id").attr("project-id")
  # channel = window.pusher.subscribe("project-#{projectId}")
  # channel.bind "scenario_completed", (data)->
  #   data.authenticity_token = $("input[name='authenticity_token']").val()
  #   if $("#selectBrowers_#{data.scenario_id}").length == 0 && $("#projects").find("table.table").find("tr").length > 0
  #     $("#projects").find("table.table").prepend(testTemplate(data))
  #     $("#selectBrowers_#{data.scenario_id}").find("input[type='checkbox']").on "change", () ->
  #       switchRunTestButton(this)

