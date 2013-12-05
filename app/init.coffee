# Module: init
# You put any application initialization code here
$('html').removeClass('no-js').addClass('js')

# require 'lib/view-helpers'
window.app= app= require 'app'

# If you want to see all the events fired from app (useful for debugging)
# app.logEvents()

app.addInitializer (opts)->
  # Do some initialization stuff here...

app.once 'app:initialized', ->
  # app.attachTo 'body', method:'html'
  unless Backbone.history.start()
    app.trigger('page:missing')
  console.log "Ready."

$ -> # Initialize the application on DOM ready event.
  console.log "#{ app.title } v#{ app.version }"
  app.start debug:(location.hostname is 'localhost')
