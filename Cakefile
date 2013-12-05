
global.PATH=
  APP:    "./app"
  ASSETS: "./app/assets"
  BUILD:  "./public"
  GEN:    "./lib/generators"
  LIB:    "./lib"
  TASKS:  "./lib/tasks"

require 'shelljs/global'
require "#{ PATH.LIB }/build-helpers"

# Auto load tasks from lib/tasks...
require "./#{ taskfile.replace(/\.coffee$/, '') }" for taskfile in ls "#{ PATH.TASKS }/*.coffee"


# bold = red = green = reset = ''
# unless process.env.NODE_DISABLE_COLORS
#   bold  = '\x1B[0;1m'
#   red   = '\x1B[0;31m'
#   green = '\x1B[0;32m'
#   reset = '\x1B[0m'
