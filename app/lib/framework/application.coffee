Controller= require './controller'
# UndoManager= require './undo-manager'

_patched= no

patchBackbone= ->
  return if _patched
  origLoadUrl= Backbone.history.loadUrl

  Backbone.history.loadUrl= (fo)->
    matched= origLoadUrl.call(Backbone.history, fo)
    # Only trigger no-match events when testing an actual fragment
    app.trigger('route:no-match', fo) if fo? and not matched
    matched

  _patched= yes


# Internal class
# class Navigator
#   constructor: (@app)->
#   go: (params...)-> @app.router.cause params...
#   matches: (params...)-> @app.router.isCaused params...
#   path: (params...)-> @app.router.getRoute params...

# Class: App
# Extends <Controller>
module.exports= 
class App extends Controller
  @instance: null

  constructor: ->
    App.instance= this
    @app= this
    @_initializers = []
    @started = false
    # @navigator= new Navigator this
    # @undoMgr= new UndoManager
    super
    patchBackbone()
    $(window).on('unload', @_windowOnUnload)

  addInitializer: (fn) ->
    if @started
      fn.call @, @_startOptions
      _.extend @, @_startOptions
    else
      @_initializers.push fn
    @
  
  start: (options={})->
    @_startOptions = options
    @trigger 'app:initializing', options

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
        _.extend @, options
        @started = true
        @trigger 'app:initialized', options
        # _.defer @trigger, 'app:ready', options
        # @trigger 'app:ready', options
        setTimeout @trigger.bind(this, 'app:ready', options), 0

    next()
    @

  origTrigger: @::trigger

  # Method: navigate
  navigate: (pathFragment, opts={})-> 
    @router.navigate pathFragment, opts
    #@navigator.go params...

  # Method: navigateTo
  # Same as navigate, but defaults to `trigger:true`
  navigateTo: (pathFragment, opts={})-> 
    @router.navigate pathFragment, _.defaults(opts, trigger:yes)

  log: (args...)->
    return unless @debug
    console.debug args...

  # Method: logEvents
  # Log all app events
  #
  # listen - Boolean. Defaults to true.
  logEvents: (listen=yes, skip...)->
    @_skipEvents= skip
    if listen
      # @on 'all', @_logEvent
      @trigger= (event, args...)=>
        console.group event
        @origTrigger event, args...
        console.groupEnd event
    else
      @trigger= @origTrigger
      # @off 'all', @_logEvent

  _logEvent: (args...)=> 
    console.debug 'app.event', args unless args[0] in @_skipEvents

  _windowOnUnload: =>
    $(window).off('unload', @_windowOnUnload)
    @dispose?()

  # Method: requireAll
  # If matching is String, matches via _.startsWith(), if regexp actually calls string.match(re).
  requireAll: (matching)->
    paths= []
    if _.isString matching
      paths.push(module) for module in window.require.list() when _.str.startsWith(module, matching) 
    else if _.isRegExp matching
      paths.push(module) for module in window.require.list() when module.match(matching)
    else
      throw "Must specify a String or RegExp to App#requireAll"
    results= {}
    for path in paths
      lib= require(path)
      if _.isPlainObject lib
        _.merge results, lib
      else
        name= _.last path.split('/')
        results[name]= lib
    results
