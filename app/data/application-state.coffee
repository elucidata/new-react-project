Cache= require 'lib/cache'
manifest= require 'manifest'
dataset= ogre or require 'ogre'
cache= new Cache 'app.state'

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
#   constructor: (data)->
#     _.extend this, data

appState= #new ApplicationStateObject

  app: 
    name: manifest.name
    version: manifest.version
    ready: no
    manifest: manifest

  page:
    current: ''
    params: null

  prefs: loadFromCache 'prefs', 
    layout: 'sidebar'

  temp: loadFromCache 'temp', 
    form: null


appDS= dataset appState, yes

saveToCache 'prefs'
saveToCache 'temp'

module.exports= appDS