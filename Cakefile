
global.PATH=
  APP:    "./app"
  ASSETS: "./app/assets"
  BUILD:  "./public"
  GEN:    "./lib/generators"
  LIB:    "./lib"
  TASKS:  "./lib/tasks"

require 'shelljs/global'
require "#{ PATH.LIB }/build-helpers"

task 'init', 'Initial setup', ->
  exec 'cake fonts:bootstrap'
  exec 'cake fonts:font-awesome'

# Auto load tasks from lib/tasks...
require "./#{ taskfile.replace(/\.coffee$/, '') }" for taskfile in ls "#{ PATH.TASKS }/*.coffee"
