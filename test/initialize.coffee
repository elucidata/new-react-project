
tests = []
framework_tests = []

for module in window.require.list()
  if _.str.endsWith module, '-test'
    if _.str.startsWith module, 'test/framework/'
      framework_tests.push module
    else
      tests.push module 
  
for test in tests
  require test

for test in framework_tests
  require test
