Controller= require './controller'

class Dispatcher extends Controller
  _routes= []

  @route: ->
    [path, event, handler]= arguments
    if type.isFunction(event)
      handler= event 
      event= null

    # console.log "-> route:", pp(path), '->', pp(event)
    _routes.push {path, event, handler}

  initialize: ->
    @_started= no

  start: ->
    return this if @_started
    # Build routes!
    self= @
    routeHash= {}
    
    for {path, event, handler} in _routes
      do (path, event, handler)->
        routeHandler= ->
          handler.apply self, arguments if handler?
          self.app.trigger event, arguments... if event?
          self.app.trigger 'route', path, arguments...
        
        if type.isArray path
          routeHash[pname]= routeHandler for pname in path
        else
          routeHash[path]= routeHandler
    
    routie routeHash
    @_started= yes
    this

  dispatch: (path)->
    routie path

  navigate: @::dispatch
  navigateTo: @::dispatch


module.exports= Dispatcher