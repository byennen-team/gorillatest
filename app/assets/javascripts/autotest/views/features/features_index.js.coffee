class Autotest.Views.FeaturesIndex extends Backbone.View

  # template: JST['features/index']

  initialize:->
    this.listenTo(this.collection, "sync", this.render)

  showCreateModal: ->
    options = {width: "400px", height: "400px", margin: "0 auto", "overflow-y": "auto", wrapperId: 'feature-modal'}
    autoTestGuiController.renderModal("add_feature_modal", options, ->
      $("input#feature_name").bind "blur", ->
        if $(this).val().length > 0
          $("button#create-feature").removeAttr("disabled")
        else
          $("button#create-feature").attr("disabled", "disabled")
        return
      )

  render: ->
    options = new Array
    $.each Autotest.features.models, (k, v) ->
      options.push "<option value='#{v.attributes.id}'>#{v.attributes.name}</option>"
    $("select#features").html("<option value=''>Select a Feature...</option>" + options.join(''))
    _this = this
    $("select#features").on "change", ->
      featureId = $(this).val()
      Autotest.Messages.Iframe.post({messageType: "setFeature", featureId: featureId}, document.referrer)
      _this.enableRecordButton()
    if this.collection.selected
      $("select#features").val(this.collection.selected)
      $("button#record").removeAttr("disabled")
      this.disableToolTip()
      this.enableRecordButton()
    else
      this.enableToolTip()
      this.enableRecordButton()
    return

  enableRecordButton: ->
    if $("select#features").val() && $("select#features").val().length > 0
      $("button#record").removeAttr("disabled")
      this.disableToolTip()
      currentFeature = Autotest.features.findWhere({id: $("select#features").val()})
      console.log(currentFeature)
      currentFeature.setCurrentFeature()
      # window.sessionStorage.setItem("autoTestRecorder.currentFeature", featureId)
    else
      $("#record").attr("disabled", "disabled")
      this.enableToolTip()

  enableToolTip: ->
    $("#record-button-wrapper").tooltip("enable")

  disableToolTip: ->
    $("#record-button-wrapper").tooltip("disable")

