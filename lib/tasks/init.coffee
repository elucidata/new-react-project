
task 'init', 'Initialize setup', ->
  exec 'npm install'
  exec 'bower install'
  invoke 'fonts:bootstrap'
  invoke 'fonts:font-awesome'
