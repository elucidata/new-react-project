
task 'docs', 'Build API docs', ->
  exec "NaturalDocs -i app/ -o HTML docs/api/ -p docs/api/meta/ -s Clean"