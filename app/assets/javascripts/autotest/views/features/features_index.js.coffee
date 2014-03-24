class Autotest.Views.FeaturesIndex extends Backbone.View

  # template: JST['features/index']

  initialize:->
    this.listenTo(this.collection, "sync", this.render)

  render: ->
    options = new Array
    $.each Autotest.autoTestFeatures.models, (k, v) ->
      options.push "<option value='#{v.attributes.id}'>#{v.attributes.name}</option>"
    $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
    _this = this
    $("select#features").on "change", ->
      featureId = $(this).val()
      parent.postMessage({messageType: "setFeature", featureId: featureId}, document.referrer)
      _this.enableRecordButton()
    if this.collection.selected
      $("select#features").val(this.collection.selected)
      $("button#record").removeAttr("disabled")
      this.disableToolTip()
      this.enableRecordButton()
    else
      this.enableToolTip()
      this.enableRecordButton()

  enableRecordButton: ->
    if $("select#features").val().length > 0
      $("button#record").removeAttr("disabled")
      this.disableToolTip()
    else
      $("#record").attr("disabled", "disabled")
      this.enableToolTip()

  enableToolTip: ->
    $("#record-button-wrapper").tooltip("enable")

  disableToolTip: ->
    $("#record-button-wrapper").tooltip("disable")

