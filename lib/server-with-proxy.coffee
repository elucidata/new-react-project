"use strict"

http = require "http"
httpProxy = require "http-proxy"
connect = require "connect"

exports.startServer = (port, path, callback) ->
  proxy= new httpProxy.RoutingProxy()  
  # .use(connect.logger("dev"))
  
  # TODO: Change '/-proxy' and 'www.google.com' below:
  # Routes all incoming http requests starting on path "/-proxy"
  app= connect()
    .use( connect.favicon() )
    .use( connect.static(path) )
    .use( "/-proxy", (req, res) ->
      console.log "Proxy:", req.originalUrl
      
      req.url = req.originalUrl
      
      proxy.proxyRequest req, res,
        host: "www.google.com"
        port: "80"
        changeOrigin: true
    )
  
  http
    .createServer( app )
    .listen port, callback