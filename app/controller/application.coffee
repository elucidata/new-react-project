App= require 'lib/framework/application'

# Class: Application
# Your application class, extends <App>
class Application extends App
  
  # FIXME: Udpate app title
  title: 'Untitled'

  # Property: routes
  # All the application routes and which appEvents they fire.
  routes:
    '*path': 'route:missing'
    '': 'route:home'

  appEvents:
    'route:home': 'route_goHome'
    'route:missing': 'route_go404'
    'app:ready': 'onReady'

  initialize: ->
    @state= require 'data/application-state'
    @version= @state.get('app.version')
    @title= @state.get('app.name')

  onStart: ->
    Root= require 'ui/layout/root'
    @root= React.renderComponent Root( @state.get() ), $('#application_root')[0]
    @state.onChange => 
      @root.setProps @state.get()

  onReady: ->
    @state.set 'app.ready', yes

  getState: (key, opts)->
    @state.get key, opts

  setState: (key, data)->
    @state.set key, data
    this

  getCursor: (key, editable=no)->
    @state.cursor key, not editable

  route_goHome: ->
    @setState 'page', current:'home', params:null
  
  route_go404: (path)->
    @setState 'page', current:'missing', params:(path or location.hash)



module.exports= Application #new Application