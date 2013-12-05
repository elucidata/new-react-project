{Model}= require 'framework'
VERSION= require 'data/models/version'

module.exports= class AppState extends Model
  @attr 'currentPage', default:'home', readonly:yes
  @attr 'version', default:VERSION, readonly:yes