
bindAppEvents= (obj, app)->
  # console.log "bindAppEvents"
  return unless obj.appEvents?
  # console.log " - here we go!"
  for own event, method of obj.appEvents
    fn= if _.isString(method)
      obj[method].bind obj
    else if _.isFunction(method)
      method
    else
      throw new Error "Event handler must be a String or Function (for event: #{event})"
    throw new Error "Event handler not found (for event: #{event})" unless fn?
    # console.log " .", event, fn #, app
    app.on(event,fn)
  @

unbindAppEvents= (obj, app)->
  return unless obj.appEvents?
  for own event, method of obj.appEvents
    fn= if _.isString(method)
      obj[method]
    else if _.isFunction(method)
      method
    app.off(event,fn)
  @

bindRouteEvents= (obj)->
  return unless obj.routes?
  obj.router or= new Backbone.Router
  for own route, event of obj.routes
    do (route, event)->
      obj.router.route route, event, (params...)->
        obj.trigger event, params...
  @

###
  Class: Controller
  
  Methods:
    
    initialize - do you thing here
    dispose - stuff

  Variables:

    appEvents - <App> events hash { "app:event": "method_name" }
    routes - Route hash

###
module.exports= class Controller
  _.extend @::, Backbone.Events  
  # _.extend @::, EventEmitter::
  
  appEvents: null
  routes: null
  
  constructor: (options={})->
    _.extend @, options
    @app or= window.app 
    unless @app?
      App= require('./application')
      @app= App.instance
    if @data?
      for key,val of @data
        @data[key]= @app.getCursor(val, yes) if _.isString val
    @initialize?(options)
    # @app?.addChild this unless @parent?
    bindAppEvents(this, @app)
    bindRouteEvents(@)    

  one: @::once

  dispose: ->
    unbindAppEvents(this, @app)
    @data[key].dispose() for key,val of @data if @data?
    @off()    

