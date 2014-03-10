# v0.5.0

#TODO: FormModel should probably handle the getting and setting the different input types separately.

Model= require './model'

# helpers
getValueFromField= (el, dom)->
  switch dom.type
    when 'radio'
      # FIXME: Change radio buttton get value
      # el.find("[name=#{dom.name}][checked]").val()
      el.find("[name=#{dom.name}]:checked").val()
    when 'checkbox'
      $(dom).is(':checked')
    else
      $(dom).val()

setValueForField= (el, field, value)->
  dom= el.find("[name=#{field}]").get(0)
  if dom
    switch dom.type

      when 'radio' # TODO: Find a better way to check radio buttons
        el.find("[name=#{field}][value=#{value}]").attr('checked', true)
        el.find("[name=#{field}][value!=#{value}]").attr('checked', false)
        el.find("[name=#{field}][value=#{value}]").prop('checked', true)
        el.find("[name=#{field}][value!=#{value}]").prop('checked', false)

      when 'checkbox'
        checkIt= value is yes or value is 'on' or value is 'true' or value is '1' or value > 0 or value == dom.value
        #log ">>>> setting checkbox", dom, " to :checked", checkIt
        $(dom).attr('checked', checkIt)
      else
        # TODO: Finish other, non .val(), input types
        $(dom).val(value)


class FieldError
  constructor: (@name, @elem)->
    label= @elem.data('display-name') or 
           @elem.parents('form').find("label[for=#{@elem.attr('id')}]").text() or 
           @elem.attr('placeholder') or 
           @name
    @displayName= _.humanize(label)
    @messages= []

  # Message: is XXXX
  #  - is required
  #  - is not a valid number
  addMessage: (msg)->
    @messages.push msg
    @

  removeMessage: (msg)->
    @messages= _.reject @messages, (message)-> message is msg
    @

  hasMessage: (msg)->
    _.contains @messages, msg

  toString: ->
    "#{@displayName} #{@messages.join(' and ')}."


class FieldErrorCollection
  _.extend @::, Backbone.Events

  constructor: ->
    @reset()

  reset: ->
    @each (error)=> @removeError error.name
    @errors = {}
    @length = 0
    @first = null
    @trigger 'reset'
    @

  addError: (field, el, msg)->
    @errors[field] or= new FieldError field, el
    return @ if @errors[field].hasMessage msg
    @errors[field].addMessage msg
    @length = _.keys(@errors).length
    @first = el unless @first
    @trigger 'add', field, msg, el, @errors[field]
    @

  removeError: (field, msg)->
    return unless @errors?
    # FIXME: Add
    error= @errors[field]
    return @ unless error?
    if msg?
      # remove specific error message
      error.removeMessage msg
    else
      # remove all errors for field
      delete @errors[field]
    @trigger 'remove', field, msg, error.elem, error
    @
  
  focusFirstError: ->
    #_.defer =>
    @first.get(0)?.focus() if @first

  isEmpty: ->
    _.isEmpty @errors

  each: (fn)-> _.each @errors, fn
  map: (fn)-> _.map @errors, fn

  toString: ->
    "#{ @map( (e)-> e.toString() ).join ' ' }"



class FormModel

  constructor: (@el, validations)->
    # console.warn 'FormModel created!', @el
    @model= new Model
    @errors= new FieldErrorCollection
    @gather()
    @originalProps= @model.toJSON()
    @_validationRules={}
    @onSubmitCallback= ->

    # How do I test if 'input' event is supported?

    @el.bind 'input', (event)=> # was 'change' event
      #console.warn 'on input', event, event.target
      @gatherOne event.target
    @el.bind 'change', (event)=> # was 'change' event
      # console.warn 'on change', event, event.target
      @gatherOne event.target
      name= event.target?.name
      # console.log "target.name", name
      if name?
        @model.trigger "changed:#{ name }"
        @model.trigger "changed", name
    @el.bind 'submit', (event)=>
      @gather()
      @onSubmitCallback(event)
    # @el.bind 'blur', (event)=> # was 'change' event
      # console.warn 'on blur', event, event.target
      # @gatherOne event.target

    # Forward events from error collection to model (and this by extension)
    @errors.on 'all', (eventName, params...)=>
      @model.trigger "error:#{ eventName }", params...

    if @validations
      @setValidations @validations
    if validations
      @setValidations validations

  setValidations: (rules, reset=false)->
    @_validationRules= {} if reset
    for own field,ruleset of rules
      @_validationRules[field] or= []
      for rule in ruleset.split ','
        @_validationRules[field].push _.trim(rule)
    @

  validate: ->
    @errors.reset()
    for own field,ruleset of @_validationRules
      err= null
      for rule in ruleset
        # console.warn "testing ", rule, "on", field, @model.get(field), FormModel.Validator.test( rule, @model.get(field) )
        if FormModel.Validator.test( rule, @model.get(field) ) is no
          @addError field, FormModel.Validator.Description.for(rule)
    @

  isValid: ->
    @validate()
    @hasErrors()

  hasErrors: ->
    @errors.isEmpty() # FIXME: Shouldn't this be !@errors.isEmpty() ??

  addError: (field, message)->
    @addErrorFor field, message

  addErrorFor: (field, message)->
    if _.isString field
      @errors.addError field, @getElemForField(field), message
    else
      @errors.addError field.attr('name'), field, message
    @

  removeErrorFor: (field, message)->
    if _.isString field
      @errors.removeError field, message
    else
      @errors.removeError field.attr('name'), message
    @


  getElemForField: (field)->
    elem= @el.find(":input[name=#{field}]")
    if elem.get(0)?.type is 'radio'
      @el.find(":input[name=#{field}][value=#{@get field}]")
    else
      elem

  numChanges: (gather_first=false)->
    @gather() if gather_first
    mismatches=0
    mismatches += 1 for own key, value of @originalProps when (@model.get(key) or "").toString() isnt (value || "").toString()
    mismatches

  isDirty: ->
    mismatches=@numChanges true
    mismatches isnt 0

  # Returns an array of changed field names
  changedFields: ->
    @gather()
    mismatches=[]
    mismatches.push(key) for own key, value of @originalProps when (@model.get(key) or "").toString() isnt (value or "").toString()
    # console.log "mismatches", mismatches
    mismatches

  populate: (obj, reset_dirty_flag=true)->
    data= if obj.toJSON then obj.toJSON() else obj
    if reset_dirty_flag
      @originalProps = _.clone data
    #console?.log "form.populate", data, @originalProps
    @set _.clone(data)
    @

  markAsClean: ->
    @gather()
    @originalProps= @toJSON()
    # TODO: Should this clear errors?
    @

  reset: (data={})->
    #console?.log "form.reset", @originalProps
    @el.get(0)?.reset()
    @set _.clone(data)
    @errors.reset()
    @

  gather: =>
    # console.warn 'gather!'
    @el.find(':input').each (idx, dom)=>
      @gatherOne dom
    @

  gatherOne: (dom)->
    # console.warn 'gatherOne', dom
    if dom.name
      # console.log "gathering", dom.name, dom
      val= getValueFromField(@el, dom)
      @model.set dom.name, val
    @

  focus: (field)->
    @getElemForField(field).get(0)?.focus()
    @

  enable: (sel=':input', updateJqmStyles=true)->
    @el.find(sel).removeAttr('disabled')
    @
  disable: (sel=':input', updateJqmStyles=true)->
    @el.find(sel).attr('disabled', yes)
    @

  enableField: (field)->
    @enable "[name=#{field}]"
  disableField: (field)->
    @disable "[name=#{field}]"
  
  enableFields: ->
    fields= _.uniq _.flatten(arguments)
    for field in fields
      @enableField field
    @
  disableFields: ->
    fields= _.flatten(arguments)
    for field in fields
      @disableField field
    @

  get: (key)->
    @model.get key

  set: (atts, value)->
    #TODO: How should #set() play with databinding and @originalProps?
    # console.warn "@form.set()", atts
    @internal_events= true
    if arguments.length is 1
      for own field,value of atts
        # console.warn 'setting field', field, 'to', value
        setValueForField @el, field, value
      @model.set atts
    else
      setValueForField @el, atts, value
      @model.set atts, value
    @internal_events= false
    @

  getAsNumber: (key)-> Number(@get key)
  getAsInt: (key, radix=10)-> parseInt(@get(key), radix)
  getAsFloat: (key)-> parseFloat(@get key)
  getAsDate: (key, format="M/D/YYYY")-> moment(@get(key), format).toDate()
  getAsBool: (key)-> Boolean(@get key)

  bind: (event, handler)->
    if event.toLowerCase() is 'submit'
      @onSubmitCallback= handler
    else
      @model.bind event, handler
    @

  on: (e,h)-> @bind(e,h)


  toJSON: (excluding=[])->
    attrs= {}
    for own field,value of @model.attributes
      unless _.include(excluding, field)
        attrs[field]=value
    attrs


  @createFrom: (sel, validations)->
    new FormModel( $(sel), validations )

  @create: (sel, validations)-> @createFrom sel, validations


  @Validator:

    define: (rule, description, fn)->
      FormModel.Validator[rule]= fn
      FormModel.Validator.Description[rule]= description
      @

    test: (rule, value)->
      # console?.log "Testing #{rule} with", value
      if @[rule]
        @[rule](value)
      else
        console.log "Cannot find validator for #{rule}"
        false

    Description:
      for: (rule)->
        FormModel.Validator.Description[rule] or FormModel.Validator.Description.unknown

      unknown: "validation failed"


FormModel.Validator.define 'required', 'is required', (value)-> value isnt null and value isnt "" and !_.isUndefined(value)

if $
  $.fn.formModel= (validations)->
    unless formModel= @data('formModel')
      formModel= new FormModel @, validations
      @data('formModel', formModel)
    # console.log "formModel() plugin", @, formModel
    formModel

module.exports= FormModel


#searchText.match(/^([\d]*[\:|.]*[\d]{2})[\s]*(?:[a|p]?[m]?)$/i)