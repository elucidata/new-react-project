
task 'fonts:bootstrap', 'Copy Bootstrap fonts to ./app/assets/fonts/', ->
  mkdir '-p', 'app/assets/fonts'
  cp "bower_components/bootstrap/fonts/*", "app/assets/fonts"


task 'fonts:font-awesome', 'Copy FontAwesome fonts to ./app/assets/fonts/', ->
  mkdir '-p', 'app/assets/fonts'
  cp "bower_components/font-awesome/fonts/*", "app/assets/fonts"
