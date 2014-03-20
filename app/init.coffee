# Module: init
# You put any application initialization code here

do -> try
  return unless (html= document.getElementsByTagName 'HTML').length > 0
  html[0].className= "#{ html[0].className.replace 'no-js', '' } js"

require('lib/js-ext')
require('lib/view-helpers').applyTo this

Application= require 'controllers/application'
window.app= app= new Application

# This will allow your modules to require('app') to get the
# Applicaton instance instead of relying on global variables.
window.require.register 'app', (e,r,m)-> m.exports= app

# If you want to see all the events fired from app
# app.logEvents()

app.addInitializer (opts)->
  # Do some initialization stuff here...

app.once 'app:ready', ->
  console.log "Ready."


# Initialize the application on DOM ready event.
document.addEventListener "DOMContentLoaded", (event)-> 
  console.log "#{ app.title } v#{ app.version }"
  app.start debug:(location.hostname is 'localhost')
