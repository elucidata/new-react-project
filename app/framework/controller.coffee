
###
  Class: Controller
  Extends <Giraffe.Contrib.Controller>

  Methods:

    initalize - stuff

  Variables:

    events - dom event hash { "click .selector": "method_name" }
    appEvents - <App> events hash { "app:event": "method_name" }
    ui - dom select varname hash { varname:".selector" } -- Creates a this.varname from $('.selector')

###
module.exports= class Controller extends Giraffe.Contrib.Controller

  # Method: constructor
  constructor: ->
    super
    @initialize?(arguments...)

  dispose: ->
    Giraffe.dispose @




return
module.exports= class Controller
  _.extend @::, Backbone.Events  
  
  appEvents: null
  
  constructor: (options={})->
    _.extend @, options
    @app ?= Giraffe.app
    @children ?= []
    @parent ?= null
    @initialize?(options)
    @app?.addChild this unless @parent?
    Giraffe.bindEventMap @, @app, @appEvents
    Giraffe.View::_bindDataEvents.call this
    
  dispose: ->
    Giraffe.dispose @, ->
      @setParent null
      @removeChildren()

  # Pull some methods over from the View impl 
  # so Controllers can be nested as well.
  setParent: Giraffe.View::setParent
  addChild: Giraffe.View::addChild
  addChildren: Giraffe.View::addChildren
  removeChild: Giraffe.View::removeChild
  removeChildren: Giraffe.View::removeChildren
  invoke: Giraffe.View::invoke


