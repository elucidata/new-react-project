{Model}= require 'framework'
Cache= require 'tools/cache'
VERSION= require 'data/models/version'

_cache= new Cache 'my-app-state'

module.exports= class AppState extends Model
  @attr 'currentPage', default:'home', transient:yes
  @attr 'version', default:VERSION, readonly:yes

  constructor: ->
    attrs= {}
    for name, opts of @.constructor.attributes
      attrs[name]= _cache.get(name, opts.default) unless opts.readonly or opts.transient
    super attrs
    @on 'change', @save

  save: =>
    for name, opts of @.constructor.attributes
      _cache.set name, @get(name) unless opts.readonly or opts.transient
    this
