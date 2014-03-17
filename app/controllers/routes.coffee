Dispatcher= require 'lib/framework/dispatcher'

class Routes extends Dispatcher

  @route ['/', ''], 'route:home', ->
    @app.setState 'page', current:'home', params:null

  @route '*', 'route:missing', (path)->
    @app.setState 'page', current:'system/missing', params:(path or location.hash)


module.exports= Routes