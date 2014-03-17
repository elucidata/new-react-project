# v0.1.1

###
  Public: Abstraction over DOMStorage, includes 
  `MemoryStorage` adaptor for unsupported browsers.
###
module.exports=
class Cache

  constructor: (@prefix='cache', storage='local')->
    # alert "No native JSON support!" unless window.JSON
    @storage=
      if storage is 'local' and window.localStorage
        # console?.log "Using LocalStorage", window.localStorage
        window.localStorage
      else if storage is 'session' and window.sessionStorage
        window.sessionStorage
      else
        # console?.log "Using MemoryStorage"
        new MemoryStorage

  set: (name, value) ->
    attrs=
      if arguments.length is 2
        (obj={})[name]= value
        obj
      else
        name
    for own key,val of attrs
      # console.log 'key,val', key, val
      @storage.setItem @_keyName(key), JSON.stringify(val)
    attrs

  get: (name, defaultValue) ->
    src= @storage.getItem(@_keyName(name))
    if src?
      JSON.parse src
    else
      defaultValue or null

  remove: (name) ->
    @storage.removeItem(@_keyName(name))

  clear: ->
    if window.localStorage
      for i in [0..@storage.length]
        key= @storage.key i
        if key.startsWith @prefix
          @storage.removeItem key
    else
      @stoage.clear()

  _keyName: (key)->
    "#{@prefix}-#{key}"


class MemoryStorage
  constructor: ->
    @clear()

  setItem: (name, value)->
    @_cache[name]= value

  getItem: (name) ->
    @_cache[name]

  removeItem: (name) -> # TODO: Validate signature
    delete @_cache[name]

  clear: ->
    @_cache= {}

