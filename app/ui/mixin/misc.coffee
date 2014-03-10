# Misc helpers for React Components
module.exports=

  domFor: (ref)-> 
    @refs[ref].getDOMNode()

  domValueFor: (ref)-> 
    # TODO: Make this smarter and return selected, or checked, values for selectboxes, checkboxes, and radio buttons.
    @refs[ref].getDOMNode().value

  getProp: (path, defaultValue)->
    parts= path.split '.'
    next= null
    obj= @props
    while parts.length
      next= parts.shift()
      return defaultValue if not obj[next]
      obj= obj[next]
    return obj

  setFocus: (ref)->
    @domFor(ref).focus()

  setValueFor: (key)->
    return (e)=>
      return if @state.isReadOnly
      (state={})[key]= e.target.value
      @setState state
  
  setValueForName: (e)->
    return if @state.isReadOnly
    key= e.target.name
    throw "setValueForName() -> Form element must have a name attribute!" unless key?
    (state={})[key]= e.target.value
    @setState state