
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

module.exports= {
  capitalize
  functionName
}


String.capitalize or= capitalize
String.functionName or= functionName
