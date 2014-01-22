//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require underscore

Pusher.log = function(message) {
  if (window.console && window.console.log) {
    window.console.log(message);
  }
};

var statusIcon = function(status){
  if (status === "pass") {
    return "<span class='pull-right glyphicon glyphicon-ok-sign status status-pass'></span>"
  }else{
    return "<span class='pull-right glyphicon glyphicon-exclamation-sign status status-fail'></span>"
  }
}

var pusher = new Pusher('963dba5416414fb92c8f');
var channel = pusher.subscribe('step_channel');
channel.bind('step_pass', function(data) {
  console.log(data.message);
  $("ul.project").append("<li>" + data.message.to_s + "<span class=pull-right>" + statusIcon(data.message.status) + "</span>" + "</li>")
});

