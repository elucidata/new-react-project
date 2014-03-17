Controller= require './controller'

###
  Public: Base application class
    
  Extends <Controller>

  Variables:

    routes - Route hash
###
module.exports= 
class App extends Controller
  @instance: null

  constructor: ->
    App.instance= this
    @app= this
    @_initializers = []
    @started = false
    super
    bindRouteEvents(@)
    $(window).on('unload', @_windowOnUnload)

  addInitializer: (fn) ->
    if @started
      fn.call @, @_startOptions
      Object.extend @, @_startOptions
    else
      @_initializers.push fn
    @
  
  start: (options={})->
    @_startOptions = options
    @trigger 'app:initializing', options

    throw new Error "No dispatcher present!" unless @dispatcher?

    if @onStart?
      @_initializers.unshift @onStart

    # Runs all sync/async initializers.
    next = (err) =>
      return error(err) if err

      fn = @_initializers.shift()
      if fn
        # Allows asynchronous calls
        if fn.length is 2
          fn.call @, options, next
        else
          fn.call @, options
          next()
      else
        Object.extend @, options
        @dispatcher.start()
        @started = true
        @trigger 'app:initialized', options
        setTimeout @trigger.bind(this, 'app:ready', options), 0

    next()
    @

  origTrigger: @::trigger

  log: (args...)->
    return unless @debug
    console.debug args...

  # Public: Log all app events
  #
  # listen - Boolean. Defaults to true.
  logEvents: (listen=yes, skip...)->
    @_skipEvents= skip
    if listen
      # @on 'all', @_logEvent
      @trigger= (event, args...)=>
        console.group event
        # console.debug event, args...
        @origTrigger event, args...
        console.groupEnd event
    else
      @trigger= @origTrigger
      # @off 'all', @_logEvent

  _logEvent: (args...)=> 
    console.debug 'app.event', args unless args[0] in @_skipEvents

  _windowOnUnload: =>
    $(window).off('unload', @_windowOnUnload)
    @dispose()

  # Public: requireAll
  # If matching is {String}, matches via s.startsWith(), if regexp actually calls string.match(re).
  requireAll: (matching)->
    paths= []
    if type.isString matching
      paths.push(module) for module in window.require.list() when module.startsWith(matching) 
    else if type.isRegExp matching
      paths.push(module) for module in window.require.list() when module.match(matching)
    else
      throw "Must specify a String or RegExp to App#requireAll"
    results= {}
    for path in paths
      lib= require(path)
      if type.isObject lib
        type.merge results, lib
      else
        [..., name]= path.split('/')
        results[name]= lib
    results

  dispose: ->
    @dispatcher.dispose?()
    if App.instance is this
      App.instance= null
    this


bindRouteEvents= (app)->
  return unless app.routes?

  for own route,event of app.routes
    do (route, event)->
      routie route, ->
        app.trigger event, arguments...
