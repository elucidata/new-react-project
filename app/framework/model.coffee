###
  Class: Model

  Extends <Giraffe.Model>

  Usage:

  (start code)
  class MyModel extends Model
    @attr 'name'


  m= new MyModel name:'Matt'

  m.get('name') is m.name()
  #=> true
  (end)

###
module.exports= class Model extends Giraffe.Model

  constructor: ->
    super
    # Timestamp tracking
    if @createdOn? and @updatedOn?
      # @on 'add', @_didAdd
      @on 'change', @_didChange
      @_didAdd()

  # Method: touch
  # Updates `updatedOn` field
  touch: ->
    @_didChange()

  # Method: trackTimestamps
  # Static method to enable timestamp tracking. Also generates attr methods for _createdOn_ and _updatedOn_.
  @trackTimestamps= ->
    @attr 'createdOn', readonly:yes
    @attr 'updatedOn', readonly:yes
    @::_didChange= _didChange
    @::_didAdd= _didAdd

  ###
    Method: attr

    Static method that generates attribute methods or property accessors.
    
    name    - The String name of the Model attribute to wrap.
    options - The hash Object of options... (default: {})
              alias:    The String to use for the accessor. (default: name)
              default:  The default value for this attribute.
              property: Boolean flag (default: false)
                        true: Use property accessors.
                        false: User attribute method.
              readonly: Boolean flag (default: false)
                        true: Only reads are supported.
                        false: Reads and writes are allowed.
  ###
  @attr: (name, options={}) ->
    method_name= options.alias or name
    if options.default? 
      (@::defaults ?= {})[name]= options.default
    if options.property is yes
      methods= (get: -> @get name)
      if options.readonly isnt yes
        methods.set= (val)-> @set name, val
      Object.defineProperty @::, method_name, methods
    else
      @::[method_name]= if options.readonly is yes
        () -> @get name
      else
        (val) -> if val? then @set(name, val) else @get(name)


# Helpers

_now= ->
  (new Date).getTime()

_didChange= (model, changes)->
  changed= model?.changedAttributes() or {}
  @set('updatedOn', _now(), silent:yes) unless _.has changed, 'updatedOn'

_didAdd= ->
  unless @attributes.createdOn?
    @set 'createdOn', _now(), silent:yes
    # @_didChange()
  this
