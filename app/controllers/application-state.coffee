Cache= require 'lib/cache'
manifest= require 'manifest'
dataset= ogre or require 'ogre'
cache= new Cache 'app.state'

defaultAppState= ->
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


# Helpers

loadFromCache= (key, defaultData)->
  data= cache.get key
  
  if data?
    data
  else
    defaultData

saveToCache= (key, overrides)->
  saveIt= (k)->
    data= appDS.get(key)
    app.log "... caching change to", k, "in cache", "fp.state.#{key}" #, data, '(overriding', overrides, ')'

    saveData= if overrides? and _.isObject data
        _.extend _.clone(data), overrides 
      else 
        data

    cache.set key, saveData
  
  appDS.onChange saveIt, key



# Just for profiling... 
# class ApplicationStateObject
#   constructor: _.extend this, defaultAppState()
# appState= new ApplicationStateObject

appDS= dataset defaultAppState(), yes

saveToCache 'prefs'
saveToCache 'temp'

module.exports= appDS
