require('dotenv').load()

exports.config=

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
        before: [
          'vendor/scripts/dom-events.js'
        ]
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
    path: "./lib/server-with-proxy"
    # port: 8080
    run: true

  plugins:
    
    react:
      autoIncludeCommentBlock: yes
      harmony: yes

  # workers:
  #   enabled: true
  #   count: 4
  #   extensions: ['less', 'styl', 'coffee', 'jsx']

  keyword:
    filePattern: /\.(js|css|html|txt)$/

    # Extra files to process which `filePattern` wouldn't match
    # extraFiles: [
    #   'public/version.txt'
    # ]

    # By default keyword-brunch has these keywords: (using information from package.json)
    #     {!version!}, {!name!}, {!date!}, {!timestamp!}
    map:
      mode: 'dev'
      built: -> (new Date).toISOString()

  overrides:
    production:
      keyword:
        map:
          mode: 'production'

