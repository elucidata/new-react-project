require('lib/js-ext')

tests = []
framework_tests = []

for module in window.require.list()
  if module.endsWith '-test'
    if module.startsWith 'test/framework/'
      framework_tests.push module
    else
      tests.push module 
  
for test in tests
  require test

for test in framework_tests
  require test
