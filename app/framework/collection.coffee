Model= require './model'

###
  Class: Collection
  Extends <Giraffe.Collection>
###
module.exports= class Collection extends Giraffe.Collection
  # Attribute: model
  # <Model> class
  model: Model

  constructor: ->
    super
    # Localstorage
    if @localStorage? and _.isString @localStorage
      @localStorage= new Backbone.LocalStorage @localStorage
