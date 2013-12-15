
init=->
  mkdir '-p', 'public'
  # unless test '-d', "#{PATH.BUILD}/javascripts/ace"
  #   echo "Copying vendor/ace into #{PATH.BUILD}/javascripts"
  #   cp '-R', 'vendor/ace', "#{PATH.BUILD}/javascripts"

spawn_brunch= (cmd, opts...)->
  proc= spawn_loud 'brunch', [cmd].concat(opts)
  proc.stderr.on 'data', (data)-> console.error data.toString('utf-8')
  proc.stdout.on 'data', (data)-> log data.toString('utf-8').trim()
  proc

brunch= (cmd, opts="", silent=no, async=no)->
  init()
  exec_loud "brunch #{cmd} #{opts}", {silent, async}

task 'build', "Builds the app into #{PATH.BUILD}", ->
  brunch 'build'
  echo "Done."

task 'build:dist', 'Calls tasks: clean, version:update, build:optimize', ->
  invoke 'clean'
  invoke 'version:update'
  invoke 'build:optimize'

task 'build:optimize', "Builds optimized app into #{PATH.BUILD}", ->
  brunch 'build', '--production'
  echo "Done."

task 'build:watch', "Watch #{PATH.APP} and autobuild to #{PATH.BUILD} on change", ->
  spawn_brunch 'watch', '--server'

task 'build:server', "Starts dev server", ->
  spawn_brunch 'watch', '--server'
