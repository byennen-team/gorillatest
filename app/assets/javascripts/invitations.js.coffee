$ ->
  $("#user_email").tagsInput
    width: "100%"
    defaultText: ""

  search = location.search.substring(1)
  params = JSON.parse "{\"" + decodeURI(search).replace(/"/g, "\\\"").replace(/&/g, "\",\"").replace(RegExp("=", "g"), "\":\"") + "\"}"

  if params.project_id
    $("#project_id").val(params.project_id)

