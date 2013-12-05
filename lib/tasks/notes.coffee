# TODO: describe missing functionality that should be added at a later date
# FIXME: describe broken code that must be fixed
# OPTIMIZE: describe code that is inefficient and may become a bottleneck
# HACK: describe the use of a questionable (or ingenious) coding practice
# REVIEW: describe code that should be reviewed to confirm implementation
# NOTE: point out something that should be taken note of

annotations= "todo fixme optimize hack review note".split(' ')

task 'notes', "Show all annotations in source", ->
  # invoke "notes:#{annotation}" for annotation in annotations
  output= ""
  for annotation in annotations
    output += grep_annotation(annotation)
  echo_overview output

annotations.forEach (annotation)->
  task "notes:#{annotation}", "Show '#{ annotation.toUpperCase() }:' annotations in source", ->
    echo_overview grep_annotation(annotation)


grep_annotation= (note)->
  exec("grep '#{note.toUpperCase()}:' -n -r #{ PATH.APP }", silent:yes).output

echo_overview= (output)->
  cache= {}
  
  for line in output.split '\n'  
    parts= line.split(':')
    continue if parts.length < 3
    filename= parts.shift().trim()
    lineNum= parts.shift().trim()
    notes= parts.join(':').trim()
    (cache[filename] ?= []).push "#{lineNum}:  #{notes}"
  
  for file, notes of cache
    echo file
    echo notes.join('\n')
    echo '\n'
