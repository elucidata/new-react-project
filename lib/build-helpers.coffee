path= require 'path'
cp = require('child_process')

global.spawn= (cmd, args=[], opts={})->
  cp.spawn cmd, args, opts

global.spawn_loud= (cmd, args=[], opts={})->
  echo "#{cmd} #{args.join ' '}"
  spawn cmd, args, opts

global.log = (args...)->
  console.log.apply console, args

global.resolvePath= (string)->
  string = process.env.HOME + string.substr(1) if string.substr(0,1) is '~'
  path.resolve(string)

global.exec_loud= (cmd, opts={})->
  echo cmd
  exec cmd, opts

# log "LOADED"