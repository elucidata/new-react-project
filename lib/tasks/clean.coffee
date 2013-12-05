
task 'clean', "Removes #{PATH.BUILD}", ->
  rm '-rf', PATH.BUILD
