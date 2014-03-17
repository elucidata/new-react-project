App= require 'lib/framework/application'
Dispatcher= require './routes'
State= require './state'

# Class: Application
# Your application class, extends <App>
class Application extends App

  appEvents:
    'app:ready': 'onReady'

  initialize: ->
    @dispatcher= new Dispatcher
    @state= (new State).dataset
    @version= @state.get('app.version')
    @title= @state.get('app.name')

  onStart: ->
    Root= require 'layouts/root'
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


module.exports= Application #new Application