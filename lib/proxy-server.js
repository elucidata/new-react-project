"use strict";

var http = require("http"),
    httpProxy = require("http-proxy"),
    connect = require("connect");

exports.startServer = function (port, path, callback) {
    var proxy = new httpProxy.RoutingProxy();

    var app = connect()
        .use(connect.favicon())
        // .use(connect.logger("dev"))
        .use(connect.static(path))

        // TODO: Change '/-proxy' and 'www.google.com' below:
        // Routes all incoming http requests starting on path "/-proxy"
        .use("/-proxy", function (req, res) {
            console.log("Proxy:", req.originalUrl)
            req.url = req.originalUrl;
            proxy.proxyRequest(req, res, {
                host: "www.google.com",
                port: "80",
                changeOrigin: true
            });
        });

    http.createServer(app).listen(port, callback);
};