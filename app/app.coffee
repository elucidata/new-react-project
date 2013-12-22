App= require 'framework/application'
AppState= require 'data/models/app-state'

# Class: Application
# Your application class, extends <App>
class Application extends App
  
  # FIXME: Udpate app title
  title: 'Untitled'

  # Property: routes
  # All the application routes and which appEvents they fire.
  routes:
    '*path': 'page:missing'
    '': 'page:home'

  appEvents:
    'page:home': 'route_goHome'
    'page:missing': 'route_go404'
    'app:initialized': 'app_onInit'

  initialize: ->
    @state= new AppState
    @version= @state.version()
    @title= @state.title()

  app_onInit: ->
    Root= require 'ui/layouts/root'
    @root= Root appState:@state.toJSON()
    
    @state.on 'change', => 
      @root.setState @state.toJSON()

    React.renderComponent @root, $('body')[0]

  setState: (state, value)->
    @state.set state, value
    @

  route_goHome: ->
    # console.log "HOME!"
    @setState currentPage:'home'
  
  route_go404: (path)->
    # console.log "404"
    @setState
      currentPage: 'missing'
      path: path #location.hash



module.exports= new Application