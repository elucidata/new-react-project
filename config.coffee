exports.config =

  # See http://brunch.io/#documentation for docs.
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app|test)/
        'test/javascripts/test.js': /^test[\\/](?!vendor)/
        'test/javascripts/test-vendor.js': /^test[\\/](?=vendor)/
      order:
        # Files in `vendor` directories are compiled before other files
        # even if they aren't specified in order.before.
        before: []
        after: [
          'test/vendor/scripts/test-helper.js'
        ]


    stylesheets:
      joinTo: 
        'stylesheets/app.css': /^(app|vendor|bower_components)/
        'test/stylesheets/test.css': /^test/

    templates:
      joinTo: 'javascripts/app.js'

  server:
    path: "./lib/proxy-server.js"
    # port: 8080
    run: true

  plugins:
    react:
      autoIncludeCommentBlock: yes
      harmony: yes
