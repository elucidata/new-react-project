semver= require 'semver'

build_date= ->
  exec("date +%y%m%d%H%M", silent:yes).output.trim()

package_version= ->
  require('../../package.json').version

git_commit_count= ->
  exec("git log --oneline | wc -l", silent:yes).output.trim()

new_version= ->
  ver= package_version()
  [major, minor, patch]= ver.split('.')
  # patch = git_commit_count()
  patch = parseInt(patch, 10) + 1
  [major, minor, patch].join('.')

update_json= (path, callback)->
  data= require "../.#{path}"
  callback data
  output= JSON.stringify(data, null, 2)
  output.to "#{path}"
  echo "  updated #{path}"


task 'version', 'Prints current app version', ->
  echo package_version()


# TODO: Transition cake version:update to using mversion
option '-f', '--force', "(ver) Force updating for version files"
task 'version:update', 'Updates all the files that contain version info', (options)->
  ver= package_version()
  new_ver= new_version()
  
  if new_ver isnt ver or options.force
    echo "v", new_ver
    
    update_json './package.json', (pkg)->
      pkg.version= new_ver
    
    update_json './bower.json', (bwr)->
      bwr.version= new_ver

    # update_json './app/manifest.json', (info)->
    #   info.version= new_ver
    #   info.built= (new Date()).toString()