
global.PATH=
  APP:    "./app"
  ASSETS: "./app/assets"
  BUILD:  "./public"
  GEN:    "./lib/generators"
  LIB:    "./lib"
  TASKS:  "./lib/tasks"

require 'coffee-script/register'
require 'shelljs/global'
require "#{ PATH.LIB }/build-helpers"

# I want the init task to show first
require "#{ PATH.TASKS }/init"

# Auto load tasks from lib/tasks...
require "./#{ taskfile.replace(/\.coffee$/, '') }" for taskfile in ls "#{ PATH.TASKS }/*.coffee"
