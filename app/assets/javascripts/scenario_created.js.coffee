$ ->

  testTemplate = _.template '<li class="scenario scenario_<%=scenario_id %>" style="margin-bottom: 5px;">
    <div class="pull-right" style="color: white;">
      <a class="btn btn-success btn-xs" href="javascript:void(0)" onclick="$(\'#test_run-<%=scenario_id %>\').slideToggle();"><span class=" glyphicon glyphicon-play"></span> Play</a>
      <a class="btn btn-success btn-xs" href="http://localhost:3000/test/thankyou?project_id=5395e9f85068693477020000&amp;developer=true&amp;scenario_id=<%=scenario_id %>" target="_blank"><span class=" glyphicon glyphicon-play"></span> Play Developer Mode</a>
    </div>
    <h5 style="display: inline;">
      <a href="/projects/my-sample-project-2/tests/fj-iewofj-ewiofjewiojewioj/test_runs"><%= scenario_name %></a>
    </h5>
    <div id="test_run-<%=scenario_id %>" style="display: none;">
      <h4 style="font-weight: bold; margin-top: 10px;">Start A New Test Run</h4>
      <form accept-charset="UTF-8" action="/projects/<%=project_id%>/tests/<%=scenario_id %>/run" class="scenario-run" id="scenario_<%=scenario_id %>" method="post"><div style="margin:0;padding:0;display:inline"><input name="utf8" type="hidden" value="✓"><input name="authenticity_token" type="hidden" value="byyH4ANyP+QC8mbdCiqDDqoxqYmyCoosr7JQd588iSk="></div>
          <div class="pull-left" style="width: 33%">
            <h4>Windows</h4>
            <ul style="list-style-type: none;">
              <li style="border-top: 0px; padding: 2px;">
                <input id="browsers_" name="browsers[]" type="checkbox" value="windows_firefox">
                <img alt="Firefox" src="/assets/icons/firefox.png">
                Firefox
              </li>
              <li style="border-top: 0px; padding: 2px;">
                <input id="browsers_" name="browsers[]" type="checkbox" value="windows_chrome">
                <img alt="Chrome" src="/assets/icons/chrome.png">
                Chrome
              </li>
              <li style="border-top: 0px; padding: 2px;">
                <input id="browsers_" name="browsers[]" type="checkbox" value="windows_ie9">
                <img alt="Internet Explorer 9" src="/assets/icons/ie.png">
                Internet Explorer 9
              </li>
            </ul>
          </div>
          <div class="pull-left" style="width: 33%">
            <h4>Linux</h4>
            <ul style="list-style-type: none;">
              <li style="border-top: 0px; padding: 2px;">
                <input id="browsers_" name="browsers[]" type="checkbox" value="linux_firefox">
                <img alt="Firefox" src="/assets/icons/firefox.png">
                Firefox
              </li>
              <li style="border-top: 0px; padding: 2px;">
                <input id="browsers_" name="browsers[]" type="checkbox" value="linux_chrome">
                <img alt="Chrome" src="/assets/icons/chrome.png">
                Chrome
              </li>
            </ul>
          </div>
          <div class="clearfix"></div>
          <div class="buttons" style="padding: 5px; text-align: right;">
            <span class="hide concurrency-warning">
              Your plan only allows
              <span class="concurrency-limit">
                4
              </span>
              concurrent browsers for a test run
            </span>
            <input class="btn btn-primary run-test" disabled="disabled" name="commit" type="submit" value="Run Tests">
          </div>
      </form>
    </div>
  </li>'

  projectId = $("#pusher-project-id").attr("project-id")
  channel = window.pusher.subscribe("project-#{projectId}")
  channel.bind "scenario_completed", (data)->
    if $("li.scenario_#{data.scenario_id}").length == 0
      $("ul.project").prepend(testTemplate(data))

