
# Public: For simple mixins.
#
# (based on code from: https://github.com/atom/mixto)
#
# Example:
#
#   class Logging extends Mixin
#     log: -> console.log? arguments...
#
#   class MyClass
#     Logging.mixin this
#     
#     constructor: ->
#       @log 'stuff'
#
module.exports=
class Mixin
  
  @mixin: (constructor) ->
    @extend(constructor.prototype)
    for name, value of this
      if ExcludedClassProperties.indexOf(name) is -1
        constructor[name] = value unless constructor.hasOwnProperty(name)
    @included?.call(constructor)

  @extend: (object) ->
    for name in Object.getOwnPropertyNames(@prototype)
      if ExcludedPrototypeProperties.indexOf(name) is -1
        object[name] = @prototype[name] unless object.hasOwnProperty(name)
    @prototype.extended?.call(object)

  constructor: ->
    @extended?()

ExcludedClassProperties = ['__super__']
ExcludedClassProperties.push(name) for name of Mixin
ExcludedPrototypeProperties = ['constructor', 'extended']
