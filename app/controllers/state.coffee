Controller= require 'lib/framework/controller'
Cache= require 'lib/cache'
manifest= require 'manifest'
dataset= ogre or require 'ogre'
cache= new Cache 'app.state'

class State extends Controller
  @defaultAppState: ->
    app: 
      name: manifest.name
      version: manifest.version
      built: manifest.built
      ready: no

    page:
      current: ''
      params: null

    prefs: loadFromCache 'prefs', 
      layout: 'sidebar'

    temp: loadFromCache 'temp', 
      form: null

  constructor: ->
    @dataset= dataset State.defaultAppState(), yes
    
    saveToCache @dataset, 'prefs'
    saveToCache @dataset, 'temp'


# Helpers

loadFromCache= (key, defaultData)->
  data= cache.get key
  
  if data?
    data
  else
    defaultData

saveToCache= (appDS, key, overrides)->
  saveIt= (k)->
    data= appDS.get(key)
    app.log "... caching change to", k, "in cache", "fp.state.#{key}" #, data, '(overriding', overrides, ')'

    saveData= if overrides? and type.isObject data
        Object.extend Object.clone(data), overrides 
      else 
        data

    cache.set key, saveData
  
  appDS.onChange saveIt, key


module.exports= State
