
# addCommas= (str)->
#   str += ''
#   x = str.split('.')
#   x1 = x[0]
#   x2 = if x.length > 1 then '.' + x[1] else ''
#   rgx = /(\d+)(\d{3})/
#   while (rgx.test(x1))
#     x1 = x1.replace(rgx, '$1' + ',' + '$2')
#   x1 + x2

capitalize= (string)->
  string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()

_nameParser= /function (.+?)\(/

functionName= (fn, defaultName="anonymous")->
  fn.name or fn.displayName or (fn.toString().match(_nameParser) or [null,defaultName])[1]

startsWith= (str, search, position=0)->
  str.indexOf(search, position) is position

endsWith= (str, search, position=str.length)->
  position -= search.length
  lastIndex= str.lastIndexOf search
  lastIndex isnt -1 and lastIndex is position


module.exports= {
  capitalize
  startsWith
  endsWith
  functionName
}


String.capitalize or= capitalize
String.functionName or= functionName
String.startsWith or= startsWith
String.endsWith or= endsWith


String::capitalize or= -> capitalize this
String::startsWith or= (val, pos)-> startsWith this, val, pos
String::endsWith or= (val, pos)-> endsWith this, val, pos