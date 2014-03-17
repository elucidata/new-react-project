
result= (obj, attr)->
  val= obj[attr]
  if type.isFunction(val)
    val.call(obj)
  else
    val

extend= (obj, sources...)->
  for source in sources
    if source
      for key,value of source
        obj[key]= value
  obj

merge= (obj, sources...)->
  for source in sources
    if source
      for key,value of source
        if type(obj[key]) is 'object'
          obj[key]= merge {}, obj[key], value
        else
          obj[key]= value
  obj

defaults= (obj, sources...)->
  for source in sources
    if source
      for key,value of source
        unless obj[key]?
          obj[key]= value
        else if type(obj[key]) is 'object'
          obj[key]= defaults {}, obj[key], value
  obj

clone= (obj)->
  merge {}, obj

module.exports= {
  extend
  merge
  defaults
  clone
  result
}


Object.extend or= extend
Object.defaults or=  defaults
Object.merge or= merge
Object.clone or= clone
Object.result or= result
