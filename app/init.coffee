# Module: init
# You put any application initialization code here
$('html').removeClass('no-js').addClass('js')

require('lib/view-helpers').applyTo this
Application= require 'controllers/application'
window.app= app= new Application

# This will allow your modules to require('app') to get the
# Applicaton instance instead of relying on global variables.
window.require.register 'app', (e, r, m)-> m.exports= app

# If you want to see all the events fired from app
app.logEvents()

app.addInitializer (opts)->
  # Do some initialization stuff here...

app.once 'app:initialized', ->
  app.trigger('route:missing') unless Backbone.history.start()
  console.log "Ready."

$ -> # Initialize the application on DOM ready event.
  console.log "#{ app.title } v#{ app.version }"
  app.start debug:(location.hostname is 'localhost')
