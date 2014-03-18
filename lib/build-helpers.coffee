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

global.git_ensure_clean= (exitOnDirty=yes)->
  result= exec("git diff --shortstat 2> /dev/null | tail -n1", silent:yes).output
  if result isnt ""
    if exitOnDirty
      console.log "\n  There are uncommited changes in this working directory!\n  Please check in changes to proceed.\n"
      process.exit(1) 
    return no
  return yes
