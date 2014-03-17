###
  Public: Base Controller class
  
  Methods:
    
    initialize - do your thing here
    dispose - stuff

  Variables:

    appEvents - <App> events hash { "app:event": "method_name" }

###
module.exports= 
class Controller

  Object.extend @::, EventEmitter::
  
  appEvents: null
  
  constructor: (options={})->
    Object.extend @, options
    @app or= window.app 
    unless @app?
      App= require('./application')
      @app= App.instance
    if @data?
      for key,val of @data
        @data[key]= @app.getCursor(val, yes) if type.isString val
    @initialize?(options)
    # @app?.addChild this unless @parent?
    bindAppEvents(this, @app)

  trigger: @::emit
  off: @::removeListener


  navigate: (pathFragment, opts={})-> 
    @app.dispatcher.dispatch pathFragment

  navigateTo: @::navigate
  dispatch: @::navigate

  dispose: ->
    unbindAppEvents(this, @app)
    @removeAllListeners()


bindAppEvents= (controller, app)->
  return unless controller.appEvents?
  for own event, method of controller.appEvents
    fn= if type.isString(method)
      controller[method].bind controller
    else if type.isFunction(method)
      method
    else
      throw new Error "Event handler must be a String or Function (for event: #{event})"
    throw new Error "Event handler not found (for event: #{event})" unless fn?
    app.on(event,fn)
  @

unbindAppEvents= (controller, app)->
  return unless controller.appEvents?
  for own event, method of controller.appEvents
    fn= if type.isString(method)
      controller[method]
    else if type.isFunction(method)
      method
    app.off(event,fn)
  @

