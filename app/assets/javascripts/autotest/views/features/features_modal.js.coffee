class Autotest.Views.FeaturesModal extends Backbone.View

  el: $(".autotest-modal-content")

  events: {
    "click #create-feature" : "createFeature"
  }

  createFeature: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $("button#create-feature").attr("disabled", true)
    Autotest.features.create({name: $("#feature_name").val()},
      success: (model, response, options) ->
        $("button#create-feature").attr("disabled", false)
        $("#feature-modal").bPopup().close()
        $("#feature_name").val('')
        window.postMessageToIframe({messageType: "featureAdded", message: {featureName: model.attributes.name, featureId: model.attributes.id}})
        model.setCurrentFeature()
      error:  (model, response, options) ->
        $("button#create-feature").attr("disabled", false)
        if $("#feature-modal-errors").length == 0
          $("#feature-modal .autotest-modal-body").append("<ul id='feature-modal-errors'></ul>")
        $("#feature-modal-errors").html('')
        $.each response.responseJSON.errors, (i, message) ->
          $("#feature-modal-errors").append("<li class='text-danger'>#{message}</li>")
    )
