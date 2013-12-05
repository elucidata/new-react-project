UndoManager= require './undo-manager'

_patched= no

patchBackbone= ->
  return if _patched
  origLoadUrl= Backbone.history.loadUrl

  Backbone.history.loadUrl= (fo)->
    matched= origLoadUrl.call(Backbone.history, fo)
    # Only trigger no-match events when testing an actual fragment
    Giraffe.app.trigger('route:no-match', fo) if fo? and not matched
    matched

  _patched= yes

# Internal class
class Navigator
  constructor: (@app)->
  go: (params...)-> @app.router.cause params...
  matches: (params...)-> @app.router.isCaused params...
  path: (params...)-> @app.router.getRoute params...

# Class: App
# Extends <Giraffe.App>
module.exports= class App extends Giraffe.App

  constructor:->
    @navigator= new Navigator this
    @undoMgr= new UndoManager
    patchBackbone()
    super
  
  # Method: navigateTo
  navigateTo: (params...)-> 
    @navigator.go params...

  # Method: logEvents
  # Log all app events
  #
  # stop - Boolean. Defaults to false.
  logEvents: (stop)->
    if stop
      @off 'all', @_logEvent
    else
      @on 'all', @_logEvent

  _logEvent: (args...)-> console.debug 'app.event', args

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
